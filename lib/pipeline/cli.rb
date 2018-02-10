module Pipeline
  module CLI
    module_function

    DEFAULT_CONFIG_PATH = "./config/pipeline_config.rb"

    def call(config_path: DEFAULT_CONFIG_PATH)
      load(config_path) if File.exist?(config_path)

      runner = Runner.new
      runner.(Pipeline.command_block)

      if runner.success
        puts "success"
      else
        puts "failed"
      end

      runner.success
    end
  end
end
