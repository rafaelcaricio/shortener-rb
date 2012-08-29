require_relative 'shortener'
require 'sinatra/activerecord/rake'

ENV['RACK_ENV'] ||= 'development'

import 'tasks/rspec.task' if ENV['RACK_ENV'] == 'test' or ENV['RACK_ENV'] == 'development'
