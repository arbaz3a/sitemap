require_relative "steps/validate_step"
require_relative "steps/crawl_step"
require_relative "steps/save_step"
require_relative "steps/print_step"
require_relative "steps/xml_step"
require_relative "steps/hierarchy_step"

class Runner
  STEPS = [
    ValidateStep,
    CrawlStep,
    SaveStep,
    XmlStep,
    HierarchyStep,
    PrintStep
  ]

  def self.run(options)
    context = { options: options }
    STEPS.each { |step| step.call(context) }
  rescue => e
    puts e.message
    # puts e.backtrace
    exit 1
  end
end