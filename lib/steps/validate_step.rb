require_relative "../url_validator"

class ValidateStep
  def self.call(context)
    url_string = context[:options][:url]
    raise "Please Enter a URL" if url_string.nil?

    validator = UrlValidator.new(url_string)
    raise "Invalid URL" unless validator.valid?

    context[:url] = validator.url
  end
end