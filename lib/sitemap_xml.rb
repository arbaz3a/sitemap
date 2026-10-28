require "nokogiri"

class SitemapXml
  NAMESPACE = "http://www.sitemaps.org/schemas/sitemap/0.9"

  def self.build(links)
    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.urlset(xmlns: NAMESPACE) do
        links.each do |link|
          xml.url do
            xml.loc link
          end
        end
      end
    end
    builder.to_xml
  end
end