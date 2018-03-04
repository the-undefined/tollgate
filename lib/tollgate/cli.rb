module Tollgate
  module CLI
    module_function

    DEFAULT_CONFIG_PATH = "./config/tollgate_config.rb"

    def call(config_path: DEFAULT_CONFIG_PATH)
      load(config_path) if File.exist?(config_path)

      reporter = Reporter.new
      runner = Runner.new(reporter: reporter)
      runner.(Tollgate.command_block || raise(Errors::NoConfiguration))

      puts reporter.report(success: runner.success?)

      runner.success?
    end
  end
end
