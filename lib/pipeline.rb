require "pipeline/cli"

class Pipeline
  def self.configure(&block)
    $pipeline = new(&block)
  end

  attr_reader :success, :command_block

  def initialize(&command_block)
    @command_block = command_block
    @success = true
  end

  def run(command_str)
    @success = system(command_str) if @success
  end
end
