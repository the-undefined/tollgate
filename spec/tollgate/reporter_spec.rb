# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tollgate::Reporter do
  describe "#report" do
    it "outputs the records" do
      reporter = described_class.new

      reporter.record("command 1", status: :success)
      reporter.record("command 2", status: :failed)
      reporter.record("command 3", status: :not_run)

      expect(reporter.report(success: false)).to include <<~OUTPUT
        PASS: command 1
        FAIL: command 2
        NOT RUN: command 3
      OUTPUT
    end

    it "outputs a success message" do
      report = described_class.new.report(success: true)

      expect(report).to include(Tollgate::Reporter::SUCCESS_OUTPUT)
    end

    it "outputs a failed message" do
      report = described_class.new.report(success: false)

      expect(report).to include(Tollgate::Reporter::FAILED_OUTPUT)
    end
  end

  describe "#record" do
    it "stores command statuses in order" do
      reporter = described_class.new

      reporter.record("command 1", status: :success)
      reporter.record("command 2", status: :failed)
      reporter.record("command 3", status: :not_run)

      expect(reporter.records.to_a)
        .to match_array(
          [
            ["command 1", :success],
            ["command 2", :failed],
            ["command 3", :not_run]
          ]
        )
    end
  end
end
