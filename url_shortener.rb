require 'sinatra/base'
require './model'

class Url < Sinatra::Application
  URLS = Url_Shortener.new
  URL_ARRAY = []

  get '/' do
    erb :index
  end

  post '/url/add' do

    url = params[:url]
    URL_ARRAY << [URLS.shorten(url), URL_ARRAY.count+1]
    new_url = "http://serene-atoll-7447.herokuapp.com/"+URL_ARRAY[URL_ARRAY.count-1][1].to_s
    erb :shorten, :locals => {:url => url, :new_url => new_url}
  end
end