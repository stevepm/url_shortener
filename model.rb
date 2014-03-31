class UrlRepository
  attr_reader :shortened_urls, :counter

  def initialize
    @shortened_urls = []
    @counter = @shortened_urls.count
  end

  def shorten(url)
    @counter += 1
    @shortened_urls << [url, @counter, 0]
  end

  def find_url(id)
    @shortened_urls[id][0]
  end

  def increase_stats(id)
    @shortened_urls[id][2] += 1
  end

  def get_stats(id)
    @shortened_urls[id][2]
  end

  def find_id(url)
    hash = Hash[@shortened_urls.map.with_index.to_a]
    counter = 0
    hash.each_key do |key|
      if key[0] == url
        return counter + 1
      end
      counter += 1
    end
  end

end