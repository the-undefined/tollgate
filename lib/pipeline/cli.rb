module Pipeline
  module CLI
    module_function

    DEFAULT_CONFIG_PATH = "./config/pipeline_config.rb"
    SUCCESS_OUTPUT = "Pipeline ran successfully"
    FAILED_OUTPUT = "Pipeline failed"

    def call(config_path: DEFAULT_CONFIG_PATH)
      load(config_path) if File.exist?(config_path)

      runner = Runner.new
      runner.(Pipeline.command_block || raise(Errors::NoConfiguration))

      if runner.success
        puts SUCCESS_OUTPUT
      else
        puts FAILED_OUTPUT
      end

      runner.success
    end
  end
end
