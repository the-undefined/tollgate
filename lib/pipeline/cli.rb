module Pipeline
  module CLI
    module_function

    def call
      pipe = Pipeline.pipe
      pipe.instance_exec(&pipe.command_block)

      if pipe.success
        puts "success"
      else
        puts "failed"
      end

      pipe.success
    end
  end
end
