module Pipeline
  module CLI
    module_function

    DEFAULT_CONFIG_PATH = "./config/pipeline_config.rb"

    def call(config_path: DEFAULT_CONFIG_PATH)
      load(config_path) if File.exist?(config_path)

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
