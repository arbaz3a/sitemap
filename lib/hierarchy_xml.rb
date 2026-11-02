require "nokogiri"

class HierarchyXml
  def self.build(pages)
    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.pages do
        pages.each do |url, data|
          xml.page do
            xml.loc url
            xml.depth data[:depth]

            xml.parents do
              data[:parents].each do |parent|
                xml.ancestor parent
              end
            end
          end
        end
      end
    end

    builder.to_xml
  end
end