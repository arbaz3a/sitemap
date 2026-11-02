require "uri"

class UrlNormalizer
  # def self.normalize(url)
  def self.normalize(uri)
    # uri = URI(url.to_s)

    uri.fragment = nil                   
    uri.scheme = uri.scheme.downcase
    uri.host = uri.host.downcase             
    uri.path = uri.path.chomp("/")            
    uri.path = "/" if uri.path.empty?          

    uri.to_s
  end
end