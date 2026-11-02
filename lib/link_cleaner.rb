require "uri"
require_relative "url_normalizer"

class LinkCleaner
  def self.clean(raw_links, base_url)
    result = []
    base_host = base_url.host.downcase.sub(/\Awww\./, "")

    raw_links.each do |href|
      begin
        uri = URI.join(base_url, href) # handle relative issue 
        next unless uri.is_a?(URI::HTTP) # remove un-domain links
        next if uri.host.nil?

        host = uri.host.downcase.sub(/\Awww\./, "")
        next unless host == base_host

        result.push(UrlNormalizer.normalize(uri))
      rescue URI::InvalidURIError
        next
      end
    end
    result.uniq
  end
end