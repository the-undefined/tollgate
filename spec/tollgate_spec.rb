require "spec_helper"
require "fileutils"

RSpec.describe do
  describe "#reset" do
    it "removes the command block" do
      a_block = double("a block")
      Tollgate.command_block = a_block

      expect(Tollgate.command_block).to eq(a_block)

      Tollgate.reset!

      expect(Tollgate.command_block).to be_nil
    end
  end

  describe "run from the command line" do
    it "can run a configuration from the default config path" do
      command_output = "a command was run from the config file"
      tollgate_result = Tollgate::Reporter::SUCCESS_OUTPUT
      path = "config/tollgate_config.rb"

      FileUtils.mkdir_p("./config")
      File.open(path, "w+") do |file|
        file.write <<~RUBY
          Tollgate.configure do
            check %(echo '#{command_output}'; exit 0)
          end
        RUBY
      end

      expect { system "exe/tollgate" }
        .to output(a_string_including(command_output). and(a_string_including(tollgate_result)))
              .to_stdout_from_any_process

      File.delete(path)
      FileUtils.rm_rf("./config")
    end

    context "without configuration" do
      it "returns information on how to configure tollgate" do
        error_message = Tollgate::Errors::NoConfiguration.new.message

        expect { system "exe/tollgate" }.to output(a_string_including(error_message))
                                              .to_stderr_from_any_process
      end
    end
  end
end
