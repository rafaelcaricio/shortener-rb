# -*- coding: utf-8 -*-

require "spec_helper"

describe 'The url shortener application' do

  it 'should be possible to access the front page' do
    get '/'
    last_response.should be_ok
  end

  it 'should be possible to create a new shortened url' do
    post '/', :url => "http://caricio.com"
    last_response.status.should == 302
    last_response['Location'].should == 'http://example.org/1+'
  end

  it 'should not be possible call post without the :url param' do
    post '/'
    last_response.status.should == 404
  end

  it 'should be possible to be redirected when access an shortened url' do
    Models::ShortenedUrl.create original_url: "http://caricio.com"

    header 'User-Agent', 'Chrome'
    get '/1'

    last_response.status.should == 302
    last_response['Location'].should == 'http://caricio.com'

    url = Models::ShortenedUrl.find_by_original_url "http://caricio.com"
    url.access_to_url.size.should == 1
    url.access_to_url.first.browser_name.should == 'Chrome'
  end

  it 'should be possible to see analytivcs for the shortened url I just made' do
    Models::ShortenedUrl.create original_url: "http://caricio.com"

    get '/1+'
    last_response.status.should == 200
  end

  it 'when requested to a invalid shortened url should redirect to 404 page' do
    get '/Op'
    last_response.status.should == 404
  end

  it 'when requested to a invalid analytics url should redirect to 404 page' do
    get '/sA+'
    last_response.status.should == 404
  end
end

describe 'With my models' do

  it 'I can create a url' do
    Models::ShortenedUrl.create original_url: "http://caricio.com"
    from_db = Models::ShortenedUrl.find_by_original_url "http://caricio.com"
    from_db.original_url.should == "http://caricio.com"
  end

  it 'I can create an access to an url' do
    url = Models::ShortenedUrl.create original_url: "http://caricio.com"
    Models::AccessToUrl.create browser_name: 'chrome', shortened_url: url
    Models::AccessToUrl.create browser_name: 'firefox', shortened_url: url

    url = Models::ShortenedUrl.find_by_original_url "http://caricio.com"
    url.access_to_url.size.should == 2
    url.access_to_url.order('created_at').first.browser_name.should == 'chrome'
  end

end
