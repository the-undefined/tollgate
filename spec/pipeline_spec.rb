require "rspec"
require "./lib/pipeline"

RSpec.describe do
  it "runs a successful command" do
    pipe = Pipeline.configure do
      run "./spec/scripts/exit_success"
    end

    result = nil
    expect { result = Pipeline::CLI.() }.to output(a_string_including("success")).to_stdout

    expect(result).to eq(true)
  end

  it "runs a failed command" do
    pipe = Pipeline.configure do
      run "./spec/scripts/exit_failed"
    end

    result = nil

    expect { result = Pipeline::CLI.() }.to output(a_string_including("failed")).to_stdout

    expect(result).to eq(false)
  end
end
