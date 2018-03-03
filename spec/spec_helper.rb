require "byebug"
require "rspec"
require "pipeline"

RSpec.configure do |config|
  config.before(:each) do
    Pipeline.reset!

    path = "config/pipeline_config.rb"
    if File.exists?(path)
      File.delete(path)
      FileUtils.rm_rf("./config")
    end
  end
end
