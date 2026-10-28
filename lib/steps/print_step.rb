class PrintStep
  def self.call(context)
    puts "\nVisited Links\n"
    puts context[:links]
  end
end