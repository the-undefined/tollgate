require "pipeline/cli"
require "pipeline/runner"

module Pipeline
  class << self
    attr_accessor :pipe
  end

  def self.configure(&block)
    self.pipe = Runner.new(&block)
  end
end
