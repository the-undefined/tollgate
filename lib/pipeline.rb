require "pipeline/cli"
require "pipeline/runner"

module Pipeline
  class << self
    attr_accessor :config
  end

  def self.configure(&block)
    self.config = block
  end
end
