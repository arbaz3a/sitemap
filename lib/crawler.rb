require "set"
require "uri"

class Crawler
   def initialize(start_url, fetcher:, extractor:, cleaner:, max_depth: nil)
    @queue = [[start_url, 0]]
    @visited = Set.new([start_url])
    @fetcher = fetcher
    @extractor = extractor
    @cleaner = cleaner
    @max_depth = max_depth
  end

  def crawl
    until @queue.empty?
      f_link, depth = @queue.shift
      
      page = @fetcher.fetch(URI(f_link))
      raw_links = @extractor.extract(page.body)
      clean_links = @cleaner.clean(raw_links, page.url)
      yield(f_link, depth, clean_links.size, @queue.size, page.error) if block_given?

      if @max_depth.nil? || depth < @max_depth
        clean_links.each do |link|
          next if @visited.include?(link)
          @visited.add(link)
          @queue << [link, depth + 1]
        end
      end
    end
  end

  def result
    puts "\nVisited Links \n"
    @visited.to_a
  end
end