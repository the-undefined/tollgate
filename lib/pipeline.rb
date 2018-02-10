require "pipeline/cli"
require "pipeline/runner"
require "pipeline/errors"

module Pipeline
  class << self
    attr_accessor :command_block
  end

  def self.configure(&block)
    self.command_block = block
  end

  def self.reset!
    self.command_block = nil
  end
end
