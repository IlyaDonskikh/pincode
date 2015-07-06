ENV['RACK_ENV'] ||= 'test'

require './config/environment'

def app
  @app ||= Pincode::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
