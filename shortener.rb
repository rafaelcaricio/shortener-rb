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

    def url
      self.id.to_s(36)
    end

    def analytics
      "#{self.id.to_s(36)}+"
    end
  end


  class AccessToUrl < ActiveRecord::Base
    validates_presence_of :browser_name
    belongs_to :shortened_url, :class_name => 'ShortenedUrl'
    before_create :normalize_user_agent

    def normalize_user_agent
      self.browser_name = case self.browser_name.downcase
        when /chrome/ then "chrome"
        when /firefox/ then "firefox"
        when /msie/ then "ie"
        else
          'others'
        end
    end
  end

end


module UrlShortener

  class App < Sinatra::Base

    get '/' do
      erb :index
    end

    post '/' do
      not_found unless params[:url]
      shortened = Models::ShortenedUrl.find_or_create_by_original_url params[:url]
      redirect shortened.analytics
    end

    get %r{^/(\w+)/?$} do |sequence|
      shortened_url = Models::ShortenedUrl.find_by_id(sequence.to_i(36))
      not_found unless shortened_url
      browser_name = if request.user_agent
                       request.user_agent
                     else
                       'others'
                     end
      Models::AccessToUrl.create browser_name: browser_name, shortened_url: shortened_url
      redirect shortened_url.original_url
    end

    get %r{^/(\w+)\+/?$} do |sequence|
      shortened = Models::ShortenedUrl.find_by_id(sequence.to_i(36))
      not_found unless shortened
      @shorten_url = shortened.url
      @all_clicks = shortened.access_to_url.size
      erb :analytics
    end

    not_found do
      status 404
      "Oops! Page cannot be found!"
    end

    helpers do

      def server_url
        @base_url ||= request.base_url
      end

      def link_to path
        "#{server_url}/#{path}"
      end

    end

  end

end
