require 'obscenity'
require 'yaml'
class UrlRepository
  attr_reader :shortened_urls, :id

  def initialize
    @shortened_urls = []
    @id = @shortened_urls.count
  end

  def shorten(url, vanity)
    if vanity == ''
      vanity = (@id + 1).to_s
    end
    @shortened_urls << [url, vanity, 0]
    @id = @shortened_urls.count
  end

  def vanity_taken?(vanity)
    @shortened_urls.each do |url_row|
      if url_row[1] == vanity
        return true
      end
    end
    false
  end

  def find_url(id)
    url = ""
    @shortened_urls.each do |url_row|
      if url_row.include?(id)
        url = url_row[0]
      end
    end
    url
  end

  def increase_stats(id)
    count = 0
    @shortened_urls.each do |url_row|
      if url_row[1] == id
        @shortened_urls[count][2] += 1
      end
      count += 1
    end
  end

  def get_stats(id)
    stats = 0
    @shortened_urls.each do |url_row|
      if url_row.include?(id)
        stats = url_row[2]
      end
    end
    stats
  end

  def find_id(url)
    id = nil
    @shortened_urls.each do |url_row|
      if url_row.include?(url)
        id = url_row[1]
      end
    end
    id.to_s
  end

end
Obscenity.configure do |config|
  config.blacklist = './words.yml'
end