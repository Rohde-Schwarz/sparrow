require 'rspec'
require 'rspec/its'
require 'rack/test'

Dir[File.join(File.dirname(__FILE__),"/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include RackAppHelper,  type: :rack
  config.include RailsAppHelper, type: :rails
  config.include UnitSpecHelper, type: :unit
end
