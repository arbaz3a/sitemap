require_relative "../link_storage"

class SaveStep
  FILE_NAME = "links.txt"

  def self.call(context)
    LinkStorage.new(FILE_NAME).save(context[:links])
  end
end