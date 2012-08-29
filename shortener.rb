# -*- coding: utf-8 -*-

require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'


module Models

  class ShortenedUrl < ActiveRecord::Base
    validates_format_of :original_url, with: /^https?:\/\/.*$/
    validates_uniqueness_of :original_url
    validates_presence_of :original_url
    has_many :access_to_url, :class_name => 'AccessToUrl', :dependent => :destroy, :foreign_key => 'shortened_url_id'


    def shorten_url request
      port_schema = ""
      if request.port != 80 
        port_schema = ":#{request.port}"
      end
      "http://#{request.host}#{port_schema}/#{self.id.to_s(36)}"
    end

    def analytics_url request
      "#{shorten_url(request)}+"
    end

  end


  class AccessToUrl < ActiveRecord::Base
    validates_presence_of :browser_name
    belongs_to :shortened_url, :class_name => 'ShortenedUrl'
  end

end


module UrlShortener

  class App < Sinatra::Base

    get '/' do
      erb :index
    end

    post '/' do
      not_found unless params[:url]
      shortened_url = Models::ShortenedUrl.find_or_create_by_original_url params[:url]
      redirect to(shortened_url.analytics_url(request))
    end

    get %r{^/(\w+)/?$} do |sequence|
      shortened_url = Models::ShortenedUrl.find_by_id(sequence.to_i(36))
      not_found unless shortened_url
      browser_name = 'other' unless request.user_agent
      Models::AccessToUrl.create(browser_name: browser_name, shortened_url: shortened_url)
      redirect to(shortened_url.original_url)
    end

    get %r{^/(\w+)\+/?$} do |sequence|
      shortened_url = Models::ShortenedUrl.find_by_id(sequence.to_i(36))
      not_found unless shortened_url
      @shorten_url = shortened_url.shorten_url request
      @all_clicks = shortened_url.access_to_url.size
      erb :analytics
    end

    not_found do
      status 404
      "Oops! Page cannot be found!"
    end

  end

end
