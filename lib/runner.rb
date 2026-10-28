require_relative "steps/validate_step"
require_relative "steps/crawl_step"
require_relative "steps/save_step"
require_relative "steps/print_step"
require_relative "steps/xml_step"

class Runner
  STEPS = [
    ValidateStep,
    CrawlStep,
    SaveStep,
    XmlStep,
    PrintStep
  ]

  def self.run(options)
    context = { options: options }
    STEPS.each { |step| step.call(context) }
  rescue => e
    puts e.message
    exit 1
  end
end