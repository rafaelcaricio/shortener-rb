# -*- coding: utf-8 -*-

require File.join(File.dirname(__FILE__), '..', 'shortener.rb')

require "sinatra"
require 'active_record'
require "rack/test"

set :environment, :test

def app
  UrlShortener::App
end


RSpec.configure do |config|
  config.include Rack::Test::Methods

  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
  ActiveRecord::Migrator.up "db/migrate"

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

end
