require "spec_helper"

RSpec.describe Pipeline::CLI do
  it "runs a successful command" do
    Pipeline.configure do
      run %(exit 0)
    end

    result = nil
    expect { result = Pipeline::CLI.() }
      .to output(a_string_including(Pipeline::Reporter::SUCCESS_OUTPUT))
            .to_stdout

    expect(result).to eq(true)
  end

  it "runs a failed command" do
    Pipeline.configure do
      run %(exit 1)
    end

    result = nil
    expect { result = Pipeline::CLI.() }
      .to output(a_string_including(Pipeline::Reporter::FAILED_OUTPUT))
            .to_stdout

    expect(result).to eq(false)
  end

  context "Pipeline has not been configured" do
    it "returns an informative error" do
      expect { Pipeline::CLI.() }.to raise_exception(Pipeline::Errors::NoConfiguration)
    end
  end

  it "can run a group of commands" do
    expected_text = "The group is run"
    Pipeline.configure do
      group do
        run %(echo '#{expected_text}')
      end
    end

    expect { Pipeline::CLI.() }
      .to output(a_string_including((expected_text)))
            .to_stdout_from_any_process
  end

  it "outputs the status of the commands" do
    Pipeline.configure do
      run %(exit 0)

      group do
        run %(exit 1)
        run %(exit 2)
      end

      run %(exit 3)
    end
    cmd_0_output = "PASS: exit 0"
    cmd_1_output = "FAIL: exit 1"
    cmd_2_output = "FAIL: exit 2"
    cmd_3_output = "NOT RUN: exit 3"

    expected_output =
      a_string_including(cmd_0_output)
        .and(a_string_including(cmd_1_output))
        .and(a_string_including(cmd_2_output))
        .and(a_string_including(cmd_3_output))

    expect { Pipeline::CLI.() }
      .to output(expected_output).to_stdout
  end
end
