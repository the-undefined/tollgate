require "spec_helper"

RSpec.describe Pipeline::CLI do
  it "runs a successful command" do
    Pipeline.configure do
      run %(exit 0)
    end

    result = nil
    expect { result = Pipeline::CLI.() }
      .to output(a_string_including(described_class::SUCCESS_OUTPUT))
            .to_stdout

    expect(result).to eq(true)
  end

  it "runs a failed command" do
    Pipeline.configure do
      run %(exit 1)
    end

    result = nil

    expect { result = Pipeline::CLI.() }
      .to output(a_string_including(described_class::FAILED_OUTPUT))
            .to_stdout

    expect(result).to eq(false)
  end
end
