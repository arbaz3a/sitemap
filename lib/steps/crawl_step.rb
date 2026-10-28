require_relative "../crawler"
require_relative "../page_fetcher"
require_relative "../link_extractor"
require_relative "../link_cleaner"

class CrawlStep
  MAX_REDIRECT_TRIES = 5

  def self.call(context)
    crawler = Crawler.new(
      context[:url].to_s,
      fetcher: PageFetcher.new(MAX_REDIRECT_TRIES),
      extractor: LinkExtractor,
      cleaner: LinkCleaner,
      max_depth: context[:options][:depth]
    )

    crawler.crawl do |url, depth, links_count, queue_size, error|
      warn "visiting: #{url} | depth: #{depth} | links on page: #{links_count} | queue: #{queue_size}"
      warn "  #{error}" if error
    end
    context[:links] = crawler.result
  end
end