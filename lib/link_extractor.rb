require "nokogiri"

class LinkExtractor
  def self.extract(html)
    doc = Nokogiri::HTML(html)
    doc.css("a[href]").map do |a|
      a["href"]
    end
  end
end