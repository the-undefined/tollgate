# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tollgate::Errors::NoConfiguration do
  it "includes the path for the default configuration file" do
    expect { raise described_class }.to raise_error(/#{Tollgate::CLI::DEFAULT_CONFIG_PATH}/)
  end
end
