require "byebug"
require "rspec"
require "pipeline"

RSpec.configure do |config|
  config.before(:each) do
    Pipeline.reset!
  end
end
