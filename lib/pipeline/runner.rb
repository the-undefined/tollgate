module Pipeline
  class Runner
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
  end
end
