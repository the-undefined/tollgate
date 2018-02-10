require "spec_helper"
require "fileutils"

RSpec.describe do
  describe "#reset" do
    it "removes the command block" do
      a_block = double("a block")
      Pipeline.command_block = a_block

      expect(Pipeline.command_block).to eq(a_block)

      Pipeline.reset!

      expect(Pipeline.command_block).to be_nil
    end
  end

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
      it "returns information on how to configure pipeline" do
        error_message = Pipeline::Errors::NoConfiguration.new.message

        expect { system "bin/pipeline" }.to output(a_string_including(error_message))
                                              .to_stderr_from_any_process
      end
    end
  end
end
