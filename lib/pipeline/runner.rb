module Pipeline
  class Runner
    attr_reader :success

    def initialize
      @success = true
    end

    def run(command_str)
      @success = system(command_str)
    end
  end
end
