class UrlRepository
  attr_reader :shortened_urls, :counter

  def initialize
    @shortened_urls = []
    @counter = @shortened_urls.count
  end

  def shorten(url)
    @counter += 1
    @shortened_urls << [url, @counter]
  end

  def find_url(id)
    @shortened_urls[id][0]
  end

end