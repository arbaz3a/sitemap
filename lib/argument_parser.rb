require "optparse"

# step 1
class ArgumentParser
  def self.parse
    options = {}
    OptionParser.new do |opt|
      opt.on("-u URL", "Enter a URL") do |url_value|
        options[:url] = url_value
      end
      opt.on("-d DEPTH", Integer, "Max depth (optional)") do |depth_value|
        options[:depth] = depth_value
      end
    end.parse!
    options
  end
end