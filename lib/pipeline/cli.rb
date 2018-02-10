module Pipeline
  module CLI
    module_function

    def call
      config = Pipeline.config
      runner = Runner.new

      runner.instance_exec(&config)

      if runner.success
        puts "success"
      else
        puts "failed"
      end

      runner.success
    end
  end
end
