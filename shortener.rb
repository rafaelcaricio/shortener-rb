# -*- coding: utf-8 -*-
#
require 'rubygems'
require 'sinatra'

class UrlShortenerApp < Sinatra::Base

  get '/' do
    'First view!'
  end

end
