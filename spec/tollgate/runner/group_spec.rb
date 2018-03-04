require "spec_helper"

RSpec.describe Tollgate::Runner::Group do
  it "checks commands successfully" do
    command_block = proc do
      check %(exit 0)
    end

    result = described_class.new.(&command_block)

    expect(result).to eq(true)
  end

  it "reports the status of commands" do
    reporter = object_double(Tollgate::Reporter.new, record: nil)

    command_block = proc do
      check %(exit 0)
      check %(exit 1)
      check %(exit 2)
    end

    described_class.new(reporter: reporter).(&command_block)

    expect(reporter).to have_received(:record).with("exit 0", status: :success)
    expect(reporter).to have_received(:record).with("exit 1", status: :failed)
    expect(reporter).to have_received(:record).with("exit 2", status: :failed)
  end

  it "outputs the comnmands output" do
    expected_text = "output from a command check"
    command_block = proc do
      check %(echo '#{expected_text}')
    end

    expect { described_class.new.(&command_block) }
      .to output(a_string_including(expected_text))
            .to_stdout_from_any_process
  end

  it "does not try to output an undefined name" do
    runner = described_class.new

    expect { runner.() }
      .not_to output(a_string_including(("Undefined")))
            .to_stdout
  end

  context "named group" do
    it "outputs the group name" do
      group_name = "the name of the group"
      runner = described_class.new(group_name)

      expect { runner.() }
        .to output(a_string_including((group_name)))
              .to_stdout
    end

    it "outputs the groupname that is a symbol" do
      group_name = :linters
      runner = described_class.new(group_name)

      expect { runner.() }
        .to output(a_string_including(("linters")))
              .to_stdout
    end
  end

  context "one of the commands fails" do
    it "returns false" do
      command_block = proc do
        check %(exit 0)
        check %(exit 1)
        check %(exit 0)
      end

      result = described_class.new.(&command_block)

      expect(result).to eq(false)
    end

    it "checks all of the commands in the group" do
      command_block = proc do
        check %(echo 'command 1'; exit 0)
        check %(echo 'coammnd 2'; exit 1)
        check %(echo 'command 3' exit 0)
      end

      runner = described_class.new

      expect { runner.(&command_block) }
        .to output(a_string_including('command 3'))
              .to_stdout_from_any_process
    end
  end
end
