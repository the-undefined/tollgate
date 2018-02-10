require "spec_helper"

RSpec.describe do
  describe "run from the command line" do
    xit "can run a successful command" do
      expect { system "bin/pipeline" }.to output(a_string_including("success"))
                                            .to_stdout_from_any_process
    end

    context "without configuration" do
      it "returns information on how to configure pipeline" do
        information = "No configuration defined. Create a configuration file at config/pipeline_config.rb"

        expect { system "bin/pipeline" }.to output(a_string_including(information))
                                              .to_stdout_from_any_process
      end
    end
  end
end
