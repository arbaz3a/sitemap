require_relative "../crawler"
require_relative "../page_fetcher"
require_relative "../link_extractor"
require_relative "../link_cleaner"
require_relative "../url_normalizer"

class CrawlStep
  MAX_REDIRECT_TRIES = 5

  def self.call(context)
    crawler = Crawler.new(
      UrlNormalizer.normalize(context[:url]),
      fetcher: PageFetcher.new(MAX_REDIRECT_TRIES),
      extractor: LinkExtractor,
      cleaner: LinkCleaner,
      max_depth: context[:options][:depth]
    )

    crawler.crawl do |url, depth, links_count, queue_size, error|
      warn "visiting: #{url} | depth: #{depth} | links on page: #{links_count} | queue: #{queue_size}"
      warn "  #{error}" if error
      # sleep 0.2
    end
    context[:pages] = crawler.pages
  end
end