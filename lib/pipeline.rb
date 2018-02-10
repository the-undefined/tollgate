require "pipeline/cli"
require "pipeline/pipe"

module Pipeline
  class << self
    attr_accessor :pipe
  end

  def self.configure(&block)
    self.pipe = Pipe.new(&block)
  end
end
