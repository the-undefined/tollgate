require "delegate"

module Pipeline
  class Reporter
    class Records < DelegateClass(Array)
      def initialize
        super([])
      end

      def to_a
        map { |record| [record.command, record.status] }
      end
    end
  end
end
