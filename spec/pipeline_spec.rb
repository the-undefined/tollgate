require "spec_helper"
require "fileutils"

RSpec.describe do
  describe "run from the command line" do
    it "can run a configuration from the default config path" do
      command_output = "a command was run"
      pipeline_result = Pipeline::CLI::SUCCESS_OUTPUT
      path = "config/pipeline_config.rb"

      FileUtils.mkdir_p("./config")
      File.open(path, "w+") do |file|
        file.write <<~RUBY
          Pipeline.configure do
            run %(echo '#{command_output}'; exit 0)
          end
        RUBY
      end

      expect { system "bin/pipeline" }
        .to output(a_string_including(command_output). and(a_string_including(pipeline_result)))
              .to_stdout_from_any_process

      File.delete(path)
      FileUtils.rm_rf("./config")
    end

    context "without configuration" do
      xit "returns information on how to configure pipeline" do
        information = "No configuration defined. Create a configuration file at config/pipeline_config.rb"

        expect { system "bin/pipeline" }.to output(a_string_including(information))
                                              .to_stdout_from_any_process
      end
    end
  end
end
