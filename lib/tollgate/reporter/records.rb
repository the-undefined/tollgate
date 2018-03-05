# frozen_string_literal: true

require "delegate"

module Tollgate
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
