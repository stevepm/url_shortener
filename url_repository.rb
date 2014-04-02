require 'obscenity'
require 'yaml'
require 'uri'
class UrlRepository
  attr_reader :shortened_urls, :id, :error_message

  def initialize
    @shortened_urls = []
    @id = @shortened_urls.count
    @error_message = ""
  end

  def url_was_shortened?(url, vanity = nil)
    valid = true
    if url.strip.empty?
      @error_message = "URL cannot be blank"
      valid = false
    elsif url.split(" ").count > 1
      @error_message = url + " is not a valid URL"
      valid = false
    elsif (url =~ /^#{URI::regexp}$/) == nil
      @error_message = url + " is not a valid URL"
      valid = false
    elsif vanity != nil
      if Obscenity.profane?(vanity)
        @error_message = "Profanity is not allowed"
        valid = false
      elsif vanity.length > 12
        @error_message = "Vanity URL must be 12 characters or shorter"
        valid = false
      elsif vanity =~ (/\d/)
        @error_message = "Vanity URL cannot contain numbers"
        valid = false
      elsif vanity_taken?(vanity)
        @error_message = vanity + " is already taken"
        valid = false
      end
    end
    if valid
      shorten(url, vanity)
      @error_message = ""
    end
    valid
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