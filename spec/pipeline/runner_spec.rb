require "spec_helper"

RSpec.describe Pipeline::Runner do
  it "runs a command block" do
    thing = double("thing")
    allow(thing).to receive(:call)
    command_block = proc { thing.call }

    expect(thing).not_to have_received(:call)

    described_class.new.(command_block)

    expect(thing).to have_received(:call).once
  end

  describe "#run" do
    context "a command run fails" do
      it "does not run subsequent commands" do
        fail_text = "this is a failure"
        success_text = "this is a success"

        command_block = proc do
          run %(echo '#{fail_text}'; exit 1)
          run %(echo '#{success_text}'; exit 0)
        end

        runner = described_class.new

        expect { runner.(command_block) }
          .to output(a_string_including(fail_text))
                .to_stdout_from_any_process

        expect { runner.(command_block) }
          .not_to output(a_string_including(success_text))
                    .to_stdout_from_any_process
      end
    end
  end

  describe "#group" do
    it "passes the command block to the group runner" do
      group_dbl = double(:group_runner, call: true)
      allow(Pipeline::Runner::Group).to receive(:new).and_return(group_dbl)

      group_command_block = Proc.new {}
      command_block = proc do
        group &group_command_block
      end

      described_class.new.(command_block)

      expect(Pipeline::Runner::Group).to have_received(:new)
      expect(group_dbl).to have_received(:call) do |_, &block|
        expect(block).to be(group_command_block)
      end
    end

    it "passes the group name to the group runner" do
      group_dbl = double(:group_runner, call: true)
      allow(Pipeline::Runner::Group).to receive(:new).and_return(group_dbl)

      group_name = "this is the group name"
      command_block = proc do
        group group_name do
          # noop
        end
      end

      described_class.new.(command_block)

      expect(Pipeline::Runner::Group).to have_received(:new).with(group_name)
    end

    it "does not run subsequent commands after a failed group"
  end
end
