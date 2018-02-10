require "spec_helper"

RSpec.describe Pipeline::Errors::NoConfiguration do
  it "includes the path for the default configuration file" do
    expect { raise described_class }.to raise_error(/#{Pipeline::CLI::DEFAULT_CONFIG_PATH}/)
  end
end
