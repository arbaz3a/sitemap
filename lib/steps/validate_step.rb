require "uri"
require_relative "../url_validator"

class ValidateStep
  def self.call(context)
    url_string = context[:options][:url]
    raise "Please Enter a URL" if url_string.nil?

    uri = URI(url_string)
    raise "Invalid URL" unless UrlValidator.valid?(uri)

    # context[:url] = URI(url_string)
    context[:url] = uri
  end
end