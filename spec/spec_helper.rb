ENV['RACK_ENV'] ||= 'test'

require './config/environment'

def app
  @app ||= Pincode::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

private

  def generate_number
    (9999 * rand).to_i.to_s
  end
