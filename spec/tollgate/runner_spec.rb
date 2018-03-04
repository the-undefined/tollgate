require "spec_helper"

RSpec.describe Tollgate::Runner do
  it "runs a command block" do
    thing = double("thing")
    allow(thing).to receive(:call)
    command_block = proc { thing.call }

    expect(thing).not_to have_received(:call)

    described_class.new.(command_block)

    expect(thing).to have_received(:call).once
  end

  it "reports the status of commands" do
    reporter = object_double(Tollgate::Reporter.new, record: nil)

    command_block = proc do
      run %(exit 0)
      run %(exit 1)
      run %(exit 2)
    end

    described_class.new(reporter: reporter).(command_block)

    expect(reporter).to have_received(:record).with("exit 0", status: :success)
    expect(reporter).to have_received(:record).with("exit 1", status: :failed)
    expect(reporter).to have_received(:record).with("exit 2", status: :not_run)
  end

  describe "#run" do
    context "a command run fails" do
      it "does not run subsequent commands" do
        fail_text = "this is a failure"
        success_text = "this is a success"

        runner = described_class.new

        expect { runner.run(%(echo '#{fail_text}'; exit 1)) }
          .to output(a_string_including(fail_text))
                .to_stdout_from_any_process

        expect(runner.success).to eq(false)

        expect { runner.run(%(echo '#{success_text}'; exit 0)) }
          .not_to output(a_string_including(success_text))
                    .to_stdout_from_any_process
      end
    end
  end

  describe "#group" do
    it "passes the reporter to the group" do
      group_dbl = double(:group_runner, call: true)
      allow(Tollgate::Runner::Group).to receive(:new).and_return(group_dbl)
      reporter = double(:reporter)
      runner = described_class.new(reporter: reporter)

      runner.group

      expect(Tollgate::Runner::Group).to have_received(:new).with(any_args, reporter: reporter)
    end

    it "passes the command block to the group runner" do
      group_dbl = double(:group_runner, call: true)
      allow(Tollgate::Runner::Group).to receive(:new).and_return(group_dbl)

      group_command_block = Proc.new {}
      command_block = proc do
        group &group_command_block
      end

      described_class.new.(command_block)

      expect(Tollgate::Runner::Group).to have_received(:new)
      expect(group_dbl).to have_received(:call) do |_, &block|
        expect(block).to be(group_command_block)
      end
    end

    it "passes the group name to the group runner" do
      group_dbl = double(:group_runner, call: true)
      allow(Tollgate::Runner::Group).to receive(:new).and_return(group_dbl)

      group_name = "this is the group name"
      command_block = proc do
        group group_name do
          # noop
        end
      end

      described_class.new.(command_block)

      expect(Tollgate::Runner::Group).to have_received(:new).with(group_name, any_args)
    end

    it "does not run subsequent commands after a failed group" do
      allow_any_instance_of(Tollgate::Runner::Group).to receive(:call).and_return(false)

      runner = described_class.new
      expect_not_to_be_output = "this text should not be echoed"
      command_block = proc do
        group do
          run %(exit 1)
        end

        run %(echo '#{expect_not_to_be_output}')
      end

      expect { runner.(command_block) }
        .not_to output(a_string_including(expect_not_to_be_output))
                  .to_stdout_from_any_process
    end

    it "does run subsequent commands after a successful group run" do
      allow_any_instance_of(Tollgate::Runner::Group).to receive(:call).and_return(true)

      runner = described_class.new
      expect_to_be_output = "this text should be echoed"
      command_block = proc do
        group do
          run %(exit 0)
        end

        run %(echo '#{expect_to_be_output}')
      end

      expect { runner.(command_block) }
        .to output(a_string_including(expect_to_be_output))
              .to_stdout_from_any_process
    end

    it "does not run subsequent group commands after a failed group run" do
      runner = described_class.new
      expect_not_to_be_output = "this text should not be echoed"
      command_block = proc do
        group do
          run %(exit 1)
        end

        group do
          run %(echo '#{expect_not_to_be_output}')
        end
      end

      expect { runner.(command_block) }
        .not_to output(a_string_including(expect_not_to_be_output))
              .to_stdout_from_any_process
    end
  end
end
