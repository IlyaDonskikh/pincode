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

  def generate_msg
    'Your pin is {{pin}}'
  end

  def generate_pin_params(id = nil, attempts = 100)
    id ||= generate_number

    {
      app_key: 'test_app_key',
      id: id,
      message: generate_msg,
      phone: nil,
      attempts: attempts,
      expire: 120
    }
  end
