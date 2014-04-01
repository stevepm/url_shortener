class UrlRepository
  attr_reader :shortened_urls, :id

  def initialize
    @shortened_urls = []
    @id = @shortened_urls.count
  end

  def shorten(url, vanity)
    if vanity == ''
      vanity = @id + 1
    end
    @shortened_urls << [url, vanity, 0]
    @id = @shortened_urls.count
  end

  def find_url(id)
    @shortened_urls.each do |url_row|
      if url_row.include?(id)
        return url_row[0]
      end
    end
  end

  def increase_stats(id)
    count = 0
    @shortened_urls.each do |url_row|
      if url_row.include?(id)
        @shortened_urls[count][2] += 1
      end
      count += 1
    end
  end

  def get_stats(id)
    @shortened_urls.each do |url_row|
      if url_row.include?(id)
        return url_row[2]
      end
    end
  end

  def find_id(url)
    @shortened_urls.each do |url_row|
      if url_row.include?(url)
        return url_row[1]
      end
    end
  end

end