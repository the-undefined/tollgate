require_relative "runner/group"

module Pipeline
  class Runner
    include Dry::Core::Constants

    attr_reader :success

    def initialize
      @success = true
    end

    def call(command_block)
      instance_exec(&command_block)
    end

    def run(command_str)
      @success = system(command_str) if @success
    end

    def group(group_name = Undefined, &command_block)
      Pipeline::Runner::Group.new(group_name).call(&command_block)
    end
  end
end
