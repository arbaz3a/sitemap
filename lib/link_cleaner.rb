require "uri"

class LinkCleaner
  def self.clean(raw_links, base_url)
    result = []
    base_host = base_url.host.sub(/\Awww\./,"")

    raw_links.each do |href|
      begin
        uri = URI.join(base_url, href) # handle relative issue 
        next unless uri.is_a?(URI::HTTP) # remove un-domain links
        next if uri.host.nil?

        host = uri.host.sub(/\Awww\./,"")
        next unless host == base_host

        uri.fragment = nil
        result.push(uri.to_s)
      rescue URI::InvalidURIError
        next
      end
    end
    result.uniq
  end
end