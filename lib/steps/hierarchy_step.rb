require_relative "../hierarchy_xml"

class HierarchyStep
  FILE_NAME = "hierarchy.xml"

  def self.call(context)
    File.write(FILE_NAME, HierarchyXml.build(context[:pages]))
  end
end