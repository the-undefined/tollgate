require "pipeline/cli"
require "pipeline/runner"

module Pipeline
  class << self
    attr_accessor :command_block
  end

  def self.configure(&block)
    self.command_block = block
  end
end
