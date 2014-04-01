require 'sinatra/base'
require './model'
require 'uri'

class Url < Sinatra::Application
  URL_REPOSITORY = UrlRepository.new


  get '/' do
    @search = params[:search]
    error_message = ''
    if @search != nil
      if @search.empty?
        error_message = "URL cannot be blank"
      else
        error_message = @search + " is not a valid URL"
      end
    end
    if @search != nil
      placeholder = @search.strip
    end

    erb :index, :locals => {:error_message => error_message, :placeholder => placeholder}
  end

  post '/url/add' do
    url = params[:url]
    if url.split(" ").count == 1
      if (url =~ /^#{URI::regexp}$/) == nil
        redirect "/?search=#{url}"
      else
        URL_REPOSITORY.shorten(URI(url).host)
        redirect "#{request.base_url}/#{URL_REPOSITORY.find_id(URI(url).host)}?stats=true"
      end
    else
      redirect "/?search=#{url.split(" ").join("+")}"
    end
  end

  get '/:id' do
    domain_url = request.base_url
    id = (params[:id].to_i)
    stat_page = params[:stats]
    if URL_REPOSITORY.id == 0
      redirect '/'
    else
      original_url = "http://"+URL_REPOSITORY.find_url(id)
      new_url = request.base_url+"/"+URL_REPOSITORY.find_id(URI(original_url).host).to_s
      stats = URL_REPOSITORY.get_stats(id)
      if stat_page == "true"
        erb :stats, :locals => {:id => id, :your_url => original_url, :stats => stats, :new_url => new_url, :domain_url => domain_url}
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