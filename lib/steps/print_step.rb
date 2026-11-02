class PrintStep
  def self.call(context)
    puts "\nVisited Links\n"
    puts context[:pages].keys
    # puts JSON.pretty_generate(context[:pages])
    # puts context[:pages].keys   # same as context[:links]
  end
end