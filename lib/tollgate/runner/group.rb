module Tollgate
  class Runner
    class Group
      include Dry::Core::Constants

      def initialize(name = Undefined, reporter: Tollgate::Reporter.new)
        @name = name
        @group_status = true
        @reporter = reporter
      end

      def group_success?
        !!@group_status
      end

      def group_failed?
        !group_success?
      end

      def call(&command_block)
        puts @name unless @name == Undefined

        instance_exec(&command_block) if block_given?

        @group_status
      end

      def run(command_str)
        result = system(command_str)
        @group_status = result if group_success?

        if result
          @reporter.record(command_str, status: :success)
        else
          @reporter.record(command_str, status: :failed)
        end
      end
    end
  end
end
