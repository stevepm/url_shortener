require 'sinatra/base'
require 'obscenity'
require './url_repository'
require 'uri'

class Url < Sinatra::Application

  URL_REPOSITORY = UrlRepository.new
  set :vanity_url => nil
  set :original_url => nil

  get '/' do
    error_message = URL_REPOSITORY.error_message

    erb :index, :locals => {:error_message => error_message, :placeholder => settings.original_url, :vanityholder => settings.vanity_url}
  end

  post '/url/add' do
    settings.original_url = params[:url]
    settings.vanity_url = params[:vanity]
    if URL_REPOSITORY.url_was_shortened?(settings.original_url, settings.vanity_url)
      shortened_url = "#{request.base_url}/#{URL_REPOSITORY.find_id(settings.original_url)}?stats=true"
      settings.vanity_url = nil
      settings.original_url = nil
      redirect shortened_url
    else
      redirect "/"
    end
  end

  get '/:id' do
    id = params[:id]
    stat_page = params[:stats]
    if URL_REPOSITORY.id == 0
      redirect '/'
    else
      original_url = URL_REPOSITORY.find_url(id)
      new_url = request.base_url+"/"+URL_REPOSITORY.find_id(original_url)
      stats = URL_REPOSITORY.get_stats(id)
      if stat_page == "true"
        erb :stats, :locals => {:id => id, :your_url => original_url, :stats => stats, :new_url => new_url, :domain_url => request.base_url}
      else
        URL_REPOSITORY.increase_stats(id)
        redirect original_url
      end
    end
  end

  not_found do
    status 404
    redirect '/'
  end

end