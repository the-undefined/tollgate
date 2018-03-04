require "byebug"
require "rspec"
require "tollgate"

RSpec.configure do |config|
  config.before(:each) do
    Tollgate.reset!

    path = "config/tollgate_config.rb"
    if File.exists?(path)
      File.delete(path)
      FileUtils.rm_rf("./config")
    end
  end
end
