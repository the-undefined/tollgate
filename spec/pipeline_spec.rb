require "rspec"
require "./lib/pipeline"

RSpec.describe do
  it "runs a successful command" do
    pipe = Pipeline.configure do
      run "./spec/scripts/exit_success"
    end

    result = pipe.start

    expect(result).to eq(true)
  end

  it "runs a failed command" do
    pipe = Pipeline.configure do
      run "./spec/scripts/exit_failed"
    end

    result = pipe.start

    expect(result).to eq(false)
  end
end
