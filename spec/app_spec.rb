describe 'pin application' do
  before do
    stub_send_sms_request
  end

  it 'create pin' do
    post 'v1/pins/', generate_pin_params

    expect(last_response.status).to eq(200)
  end

  it 'return 403 if app key invalid' do
    post 'v1/pins/', id: generate_number, message: generate_msg, app_key: '-'

    expect(last_response.status).to eq(403)
  end

  it 'return 403 if code invalid' do
    id = generate_number
    Pin::Create.call(generate_pin_params)

    get "v1/pins/#{id}/check", code: generate_number, app_key: 'test_app_key'

    expect(last_response.status).to eq(403)
  end

  it 'return 200 if code invalid' do
    id = generate_number
    pin = Pin::Create.call generate_pin_params(id)

    get "v1/pins/#{id}/check", code: pin.code, app_key: 'test_app_key'

    expect(last_response.status).to eq(200)
  end
end
