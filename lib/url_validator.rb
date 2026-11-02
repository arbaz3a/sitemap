require "uri"

class UrlValidator
  # def self.valid?(url_string)
  def self.valid?(uri)
    # uri = URI.parse(url_string)
    # uri.is_a?(URI::HTTP) && !uri.host.nil?
    uri.is_a?(URI::HTTP) && !uri.host.to_s.empty?
  rescue URI::InvalidURIError
    false
  end
end