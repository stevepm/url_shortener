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
    domain_url = request.host
    url = params[:url]
    if url.split(" ").count == 1
      if (url =~ /^#{URI::regexp}$/) == nil
        redirect "/?search=#{url}"
      else
        URL_REPOSITORY.shorten(URI(url).host)
        new_url = request.host+"/"+URL_REPOSITORY.counter.to_s
        erb :shorten, :locals => {:your_url => url, :new_url => new_url, :domain_url => domain_url}
      end
    else
      redirect "/?search=#{url.split(" ").join("+")}"
    end
  end

  get '/:id' do
    id = (params[:id].to_i) - 1
    stat_page = params[:stats]
    if URL_REPOSITORY.counter == 0
      redirect '/'
    else
      original_url = URL_REPOSITORY.find_url(id)
      stats = URL_REPOSITORY.get_stats(id)
      if stat_page == "true"
        erb :stats, :locals => {:id => id, :your_url => original_url, :stats => stats}
      else
        URL_REPOSITORY.increase_stats(id)
        redirect "http://#{original_url}"
      end
    end
  end

  not_found do
    status 404
    redirect '/'
  end

end