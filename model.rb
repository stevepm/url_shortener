class Url_Shortener
  attr_reader :shortened_urls, :counter

  def initialize
    @shortened_urls = []
    @counter = @shortened_urls.count + 1
  end

  def shorten(url)
    @shortened_urls << [url, @counter]
  end

  def get_new_url
    "http://serene-atoll-7447.herokuapp.com/"+@counter.to_s
  end
end