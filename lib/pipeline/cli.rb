module Pipeline
  module CLI
    module_function

    def call
      commands = Pipeline.command_block
      runner = Runner.new

      runner.instance_exec(&commands)

      if runner.success
        puts "success"
      else
        puts "failed"
      end

      runner.success
    end
  end
end
