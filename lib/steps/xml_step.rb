require_relative "../sitemap_xml"

class XmlStep
  FILE_NAME = "sitemap.xml"

  def self.call(context)
    File.write(FILE_NAME, SitemapXml.build(context[:links]))
  end
end
