# -*- coding: utf-8 -*-

require 'rubygems'
#require 'data_mapper'
require 'sinatra'


#DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_ROSE'] || "sqlite3://#{Dir.pwd}/database.db")

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
