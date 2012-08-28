# -*- coding: utf-8 -*-

require File.join(File.dirname(__FILE__), '..', 'shortener.rb')

require "sinatra"
require "rack/test"

set :environment, :test

def app
  UrlShortener::App
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
