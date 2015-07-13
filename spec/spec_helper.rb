ENV['RACK_ENV'] ||= 'test'

require './config/environment'
require 'webmock/rspec'

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
      phone: generate_number,
      attempts: attempts,
      expire: 120,
      sender: generate_sender
    }
  end

  def generate_sender
    {
      'geatway' => 'Sms::Smsru',
      'smsru_api_id' => generate_number
    }
  end

  def stub_send_sms_request
    body = "100\n201523-1000007\nbalance=52.54"

    stub_request(:post, 'http://sms.ru/sms/send')
      .to_return(status: 200, body: body)
  end
