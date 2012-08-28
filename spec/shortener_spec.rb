# -*- coding: utf-8 -*-

require "spec_helper"

describe 'The url shortener application' do

  it 'should respond for the front page' do
    get '/'
    last_response.should be_ok
  end

  it 'should respond for a sequence' do
    get '/somesequence'
    last_response.should be_ok
  end

  it 'should respond for a sequence with / at the end' do
    get '/somesequence/'
    last_response.should be_ok
  end

  it 'should respond for analytics page' do
    get '/somesequence+'
    last_response.should be_ok
  end

  it 'should respond for analytics page with / at the end' do
    get '/somesequence+/'
    last_response.should be_ok
  end

end
