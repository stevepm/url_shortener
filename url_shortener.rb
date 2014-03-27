require 'sinatra/base'

class Url < Sinatra::Application
  get '/' do
    erb :index
  end
end