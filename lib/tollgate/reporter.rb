require_relative "reporter/records"

module Tollgate
  class Reporter
    SUCCESS_OUTPUT = "Tollgate finished successfully"
    FAILED_OUTPUT = "Tollgate failed"

    Record = Struct.new(:command, :status)

    attr_reader :records
    def initialize
      @records = Tollgate::Reporter::Records.new
    end

    def record(command, status:)
      @records << Record.new(command, status)
    end

    STATUSES = {
      success: "PASS",
      failed: "FAIL",
      not_run: "NOT RUN"
    }

    def report(success:)
      run_result = success ? SUCCESS_OUTPUT : FAILED_OUTPUT

      <<~OUTPUT
      #{command_statuses.join}
      #{run_result}
      OUTPUT
    end

    private

    def command_statuses
      @records.map do |record|
        status = STATUSES.fetch(record.status)
        <<~OUTPUT
        #{status}: #{record.command}
        OUTPUT
      end
    end
  end
end
