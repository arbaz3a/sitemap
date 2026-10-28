require "uri"

class UrlValidator
  attr_reader :url
  def initialize(url)
    @url = URI(url)
  rescue URI::InvalidURIError
    @url = nil
  end

  def valid?
      @url.is_a?(URI::HTTP) && !@url.host.nil?
  end
end