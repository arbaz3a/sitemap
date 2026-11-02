require_relative "../link_storage"

class SaveStep
  FILE_NAME = "links.json"
  FILE_NAME_HIERARCHY = "hierarchy.json"

  def self.call(context)
    LinkStorage.save(FILE_NAME, context[:pages].keys)
    LinkStorage.save(FILE_NAME_HIERARCHY, context[:pages])
  end
end