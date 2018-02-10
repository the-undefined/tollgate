require "spec_helper"
require "fileutils"

RSpec.describe do
  describe "run from the command line" do
    it "can run a configuration from the default config path" do
      path = "config/pipeline_config.rb"
      FileUtils.mkdir_p("./config")

      File.open(path, "w+") do |file|
        file.write <<~RUBY
          Pipeline.configure do
            run "./spec/scripts/exit_success"
          end
        RUBY
      end

      expect { system "bin/pipeline" }.to output(a_string_including("success"))
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
