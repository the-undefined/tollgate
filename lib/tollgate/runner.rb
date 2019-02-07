# frozen_string_literal: true

require_relative "reporter"
require_relative "runner/group"

module Tollgate
  class Runner
    include Dry::Core::Constants

    attr_reader :success

    def initialize(reporter: Tollgate::Reporter.new)
      @success = true
      @reporter = reporter
    end

    def success?
      @success
    end

    def failed?
      !success?
    end

    def call(command_block)
      instance_exec(&command_block)
    end

    def check(command_str)
      return record_not_run(command_str) if failed?

      @success = system(command_str)

      if success?
        @reporter.record(command_str, status: :success)
      else
        @reporter.record(command_str, status: :failed)
      end
    end

    def group(group_name = Undefined, &command_block)
      return if failed?

      group_runner = Tollgate::Runner::Group.new(group_name, reporter: @reporter)
      @success = group_runner.(&command_block)
    end

    private

    def record_not_run(command_str)
      @reporter.record(command_str, status: :not_run)
    end
  end
end
