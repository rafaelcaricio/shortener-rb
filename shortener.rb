require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'config/environments'
require_relative 'helpers'
require_relative 'models'

module UrlShortener

  class App < Sinatra::Base

    helpers UrlHelpers

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
      @browsers = shortened.access_to_url.count(group: :browser_name).sort_by {|k,v| -v }
      erb :analytics
    end

    not_found do
      status 404
      "Oops! Page cannot be found!"
    end

  end

end
