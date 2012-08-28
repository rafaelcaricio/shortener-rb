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

  it 'I can create an access to an url' do
    url = ShortenedUrl.create original_url: "http://caricio.com"
    AccessToUrl.create browser_name: 'chrome', shortened_url: url
    AccessToUrl.create browser_name: 'firefox', shortened_url: url

    url = ShortenedUrl.find_by_original_url "http://caricio.com"
    url.access_to_url.size.should == 2
    url.access_to_url.order('created_at').first.browser_name.should == 'chrome'
  end

end
