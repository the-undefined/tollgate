module Tollgate
  module Errors
    class NoConfiguration < StandardError
      def message
        <<~TEXT


          ERROR: There is no configuration block defined for Tollgate
          ==========================================================

          Create a file at `#{CLI::DEFAULT_CONFIG_PATH}` and define your tollgate using the `check` method:

          ```
          Tollgate.configure do
            check "an_executable_in_my_path"
            check "another_executable_in_my_path"
          end
          ```
        TEXT
      end
    end
  end
end
