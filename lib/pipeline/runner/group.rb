module Pipeline
  class Runner
    class Group
      include Dry::Core::Constants

      def initialize(name = Undefined)
        @name = name
        @group_status = true
      end

      def call(&command_block)
        puts @name unless @name == Undefined

        instance_exec(&command_block) if block_given?

        @group_status
      end

      def run(command_str)
        result = system(command_str)
        @group_status = result unless @group_status == false
      end
    end
  end
end
