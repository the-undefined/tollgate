module Pipeline
  module Errors
    class NoConfiguration < StandardError
      def message
        <<~TEXT


          ERROR: There is no configuration block defined for Pipline
          ==========================================================

          Create a file at `#{CLI::DEFAULT_CONFIG_PATH}` and define your pipeline using the `run` method:

          ```
          Pipline.configure do
            run "./an_executable_in_my_path"
            run "./another_executable_in_my_path"
          end
          ```
        TEXT
      end
    end
  end
end
