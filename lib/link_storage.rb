require "json"

class LinkStorage
  def initialize(file_path)
    @file_path = file_path
  end

  def save(links)
    File.write(@file_path, JSON.pretty_generate(links))
    # json = JSON.generate(links)  #convert arrat into json string 
    # File.open(@file_path, "w") do |file|
    #   file.puts json
    # end
  end

  def load
    return [] unless File.exist?(@file_path)
    JSON.parse(File.read(@file_path)) #convert into ruby array or hashes
  rescue JSON::ParserError
    []
  end
end