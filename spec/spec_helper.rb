# frozen_string_literal: true

require "byebug"
require "rspec"
require "tollgate"

RSpec.configure do |config|
  config.before(:each) do
    Tollgate.reset!

    path = "config/tollgate_config.rb"
    if File.exist?(path)
      File.delete(path)
      FileUtils.rm_rf("./config")
    end
  end
end
