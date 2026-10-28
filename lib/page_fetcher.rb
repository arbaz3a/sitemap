require "uri"
require "net/http"


class PageFetcher
  Page = Struct.new(:url, :body, :error)

  def initialize(limit = 5)
    @limit = limit
  end

  def fetch(url)
    @limit.times do
      res = Net::HTTP.get_response(url)
      if res.is_a?(Net::HTTPSuccess)
        return Page.new(url, res.body, nil)
      elsif res.is_a?(Net::HTTPRedirection)
        url = URI.join(url, res["location"])
      else
        return Page.new(url, "", "issue while fetching html, #{res.code}")
      end
    end
    Page.new(url, "", "Too many redirections")
  end
end