require 'sinatra/base'
require './model'

class Url < Sinatra::Application
  URL_ARRAY = []

  get '/' do
    erb :index
  end

  post '/url/add' do
    url = params[:url]
    URL_ARRAY << [url, URL_ARRAY.count+1]
    new_url = request.host+"/"+URL_ARRAY[URL_ARRAY.count-1][1].to_s
    erb :shorten, :locals => {:url => url, :new_url => new_url}
  end

  get '/:id' do
    id = (params[:id].to_i) - 1

    if URL_ARRAY.count == 0
      redirect '/'
    else
      original_url = URL_ARRAY[id].first
      redirect "http://#{original_url}"
    end
  end


end