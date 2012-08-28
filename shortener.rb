# -*- coding: utf-8 -*-

require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'


set :database, ENV['HEROKU_POSTGRESQL_ROSE'] || "sqlite3://database.db"


class ShortenedUrl < ActiveRecord::Base
  validates_format_of :original_url, with: /^https?:\/\/.*$/
  validates_uniqueness_of :original_url
  validates_presence_of :original_url
  has_many :access_to_url, :dependent => :destroy
end


class AccessToUrl < ActiveRecord::Base
  validates_presence_of :browser_name
  belongs_to :shortened_url
end


module UrlShortener

  class App < Sinatra::Base


    get '/' do
      erb :index
    end

    post '/' do
      "shorting url"
    end

    get %r{^/(\w+)/?$} do |sequence|
      "wow, shorted! looking for sequece #{sequence}"
    end

    get %r{^/(\w+)\+/?$} do |sequence|
      "analytics for #{sequence}"
    end

    not_found do
      "Oops! Page cannot be found!"
    end

  end

end
