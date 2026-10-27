require "optparse"
require "uri"
require "net/http"
require "nokogiri"
require "json"
require "set"



class Sitemap
  MAX_REDIRECT_TRIES = 5
  FILE_NAME = "links.txt"

  def self.run
    # getting input using terminal
    options = ArgumentParser.parse
    url_string = options[:url]

    if url_string.nil?
      puts "Please Enter a URL"
      exit 1
    end

    validator = UrlValidator.new(url_string)
    unless validator.valid?
      puts "Invalid URL"
      exit 1
    end

    crawler = Crawler.new(validator.url.to_s, MAX_REDIRECT_TRIES, FILE_NAME, options[:depth])
    crawler.crawl
    puts crawler.result

    # sitemapxml = SitemapXml.new(crawler.result)
    # puts sitemapxml.builder
    
    
  end
end


# step 1
class ArgumentParser
  def self.parse
    options = {}
    OptionParser.new do |opt|
      opt.on("-u URL", "Enter a URL") do |url_value|
        options[:url] = url_value
      end
      opt.on("-d DEPTH", Integer, "Max depth (optional)") do |depth_value|
        options[:depth] = depth_value
      end
    end.parse!
    options
  end
end


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


# step 2
class PageFetcher
  attr_reader :url
  def initialize(url, limit = 5)
    @url = url
    @limit = limit
  end
  
  def fetch
    @limit.times do
      res = Net::HTTP.get_response(@url) # success 200
      if res.is_a?(Net::HTTPSuccess)
        return res.body
      elsif res.is_a?(Net::HTTPRedirection) # redirection 300
        @url = URI.join(@url, res["location"]) #@url.to_s work also, /about and base url join issue 
      else
        # puts "issue while fetching html, #{res.code}"
        warn "issue while fetching html, #{res.code}"
        return ""
      end
    end
    # puts "Too many redirections"
    warn "Too many redirections"
    ""
  end
end


# # step 3
class LinkExtractor
  def initialize(html)
     @html = html
  end

  def extract
    doc = Nokogiri::HTML(@html)
    doc.css("a[href]").map do |a|
      a["href"]
    end
  end
end


# # step 4
class LinkCleaner
  def initialize(raw_links, base_url)
    @raw_links = raw_links
    @base_url = base_url
  end

  def clean
    result = []
    base_host = @base_url.host.sub(/\Awww\./,"")

    @raw_links.each do |href|
      begin
        uri = URI.join(@base_url, href) # handle relative issue 
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


# # step 4 - part b
class LinkStorage
  def initialize(file_path)
    @file_path = file_path
  end

  def save(links)
    File.write(@file_path, JSON.pretty_generate(links))
    # json = JSON.generate(links)  #convert arrat into json string 
    # File.open(@file_path, "w") do |file|
    #   file.puts json
    # end
  end

  def load
    return [] unless File.exist?(@file_path)
    JSON.parse(File.read(@file_path)) #convert into ruby array or hashes
  rescue JSON::ParserError
    []
  end
end


# step 5 + 6
class Crawler
  def initialize(start_url, max_redirect_tries, file_name, max_depth = nil)
    @queue = [[start_url,0]]
    @visited = Set.new([start_url])
    @max_redirects = max_redirect_tries
    @file_name = file_name
    @max_depth = max_depth
  end

  def crawl
    until @queue.empty?
      f_link, depth = @queue.shift
      # validator = UrlValidator.new(f_link)
      # pagefetcher = PageFetcher.new(validator.url, @max_redirects)
      pagefetcher = PageFetcher.new(URI(f_link), @max_redirects)
      html = pagefetcher.fetch
      linkextractor = LinkExtractor.new(html)
      raw_links = linkextractor.extract
      linkcleaner = LinkCleaner.new(raw_links, pagefetcher.url)
      clean_links = linkcleaner.clean
      # puts "visiting: #{f_link} | depth: #{depth} | links on page: #{clean_links.size} | queue: #{@queue.size}"
      warn "visiting: #{f_link} | depth: #{depth} | links on page: #{clean_links.size} | queue: #{@queue.size}"

      if @max_depth.nil? || depth < @max_depth
        clean_links.each do |link|
          next if @visited.include?(link)
          @visited.add(link)
          @queue << [link, depth + 1] # alternative oof pushh
        end
      end

    end
  ensure
    linkstorage = LinkStorage.new(@file_name)
    linkstorage.save(@visited.to_a)
    # puts linkstorage.load
  end

  def result
    puts "\nVisited Links \n"
    @visited.to_a
  end

end


# step 7
# class SitemapXml
#   def initialize(links)
#     @links = links
#   end

#   def build
#     builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
#       xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
#         @links.each do |link|
#           xml.url do 
#             xml.loc link
#           end
#         end
#       end
#     end
#     builder.to_xml
#   end
# end





Sitemap.run
