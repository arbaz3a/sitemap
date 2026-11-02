require "json"

class LinkStorage
  def self.save(file_path, data)
    File.write(file_path, JSON.pretty_generate(data))
  end

  def self.load(file_path)
    return [] unless File.exist?(file_path)

    JSON.parse(File.read(file_path))
  rescue JSON::ParserError
    []
  end
end