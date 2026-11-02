require "uri"

class Crawler
  attr_reader :pages

  def initialize(start_url, fetcher:, extractor:, cleaner:, max_depth: nil)
    @queue = [[start_url, 0]]
    @fetcher = fetcher
    @extractor = extractor
    @cleaner = cleaner
    @max_depth = max_depth
    @pages = { start_url => { depth: 0, parents: [] } }
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
          next if @pages.key?(link)

          @pages[link] = {
            depth: depth + 1,
            parents: @pages[f_link][:parents] + [f_link]
          }

          @queue << [link, depth + 1]
        end
      end
    end
  end
end