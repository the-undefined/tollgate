# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tollgate::CLI do
  it "checks a successful command" do
    Tollgate.configure do
      check %(exit 0)
    end

    result = nil
    expect { result = Tollgate::CLI.() }
      .to output(a_string_including(Tollgate::Reporter::SUCCESS_OUTPUT))
      .to_stdout

    expect(result).to eq(true)
  end

  it "checks a failed command" do
    Tollgate.configure do
      check %(exit 1)
    end

    result = nil
    expect { result = Tollgate::CLI.() }
      .to output(a_string_including(Tollgate::Reporter::FAILED_OUTPUT))
      .to_stdout

    expect(result).to eq(false)
  end

  context "Tollgate has not been configured" do
    it "returns an informative error" do
      expect { Tollgate::CLI.() }.to raise_exception(Tollgate::Errors::NoConfiguration)
    end
  end

  it "can check a group of commands" do
    expected_text = "The group is check"
    Tollgate.configure do
      group do
        check %(echo '#{expected_text}')
      end
    end

    expect { Tollgate::CLI.() }
      .to output(a_string_including(expected_text))
      .to_stdout_from_any_process
  end

  it "outputs the status of the commands" do
    Tollgate.configure do
      check %(exit 0)

      group do
        check %(exit 1)
        check %(exit 2)
      end

      check %(exit 3)
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

    expect { Tollgate::CLI.() }
      .to output(expected_output).to_stdout
  end
end
