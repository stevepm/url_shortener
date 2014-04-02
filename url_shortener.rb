require 'sinatra/base'
require 'obscenity'
require './model'
require 'uri'

class Url < Sinatra::Application

  URL_REPOSITORY = UrlRepository.new
  #DOMAIN_URL = request.base_url
  set :vanity_url => nil
  set :original_url => nil

  get '/' do

    @search = params[:search]
    error_message = ''
    if @search != nil
      if @search.empty?
        error_message = "URL cannot be blank"
      elsif Obscenity.profane?(settings.vanity_url)
        error_message = "Profanity is not allowed"
      elsif settings.vanity_url.length > 12
        error_message = "Vanity URL must be 12 characters or shorter"
      elsif URL_REPOSITORY.vanity_taken?(settings.vanity_url)
        error_message = settings.vanity_url + " is already taken"
      else
        error_message = @search + " is not a valid URL"
      end
    end
    if @search != nil
      placeholder = @search.strip
    end

    erb :index, :locals => {:error_message => error_message, :placeholder => placeholder, :vanityholder => settings.vanity_url}
  end

  post '/url/add' do
    url = params[:url]
    settings.vanity_url = params[:vanity]
    if url.split(" ").count == 1
      if (url =~ /^#{URI::regexp}$/) == nil || URL_REPOSITORY.vanity_taken?(settings.vanity_url) || Obscenity.profane?(settings.vanity_url) || settings.vanity_url.length > 12
        redirect "/?search=#{url}"
      else
        URL_REPOSITORY.shorten(URI(url), settings.vanity_url)
        settings.vanity_url = nil
        redirect "#{request.base_url}/#{URL_REPOSITORY.find_id(URI(url))}?stats=true"
      end
    else
      redirect "/?search=#{url.split(" ").join("+")}"
    end
  end

  get '/:id' do
    id = params[:id]
    stat_page = params[:stats]
    if URL_REPOSITORY.id == 0
      redirect '/'
    else
      original_url = URL_REPOSITORY.find_url(id)
      new_url = request.base_url+"/"+URL_REPOSITORY.find_id(URI(original_url))
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