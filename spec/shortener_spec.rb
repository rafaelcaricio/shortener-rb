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

describe 'With my models' do

  it 'I can create a url' do
    ShortenedUrl.create original_url: "http://caricio.com"
    from_db = ShortenedUrl.find_by_original_url "http://caricio.com"
    from_db.original_url.should == "http://caricio.com"
  end

end
