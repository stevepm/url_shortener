class UrlRepository
  attr_reader :shortened_urls, :id

  def initialize
    @shortened_urls = []
    @id = @shortened_urls.count
  end

  def shorten(url)
    @id += 1
    @shortened_urls << [url, @id, 0]
  end

  def find_url(id)
    @shortened_urls[id-1][0]
  end

  def increase_stats(id)
    @shortened_urls[id-1][2] += 1
  end

  def get_stats(id)
    @shortened_urls[id-1][2]
  end

  def find_id(url)
    hash = Hash[@shortened_urls.map.with_index.to_a]
    hash.each_key do |key|
      if key[0] == url
        return key[1]
      end
    end
  end

end