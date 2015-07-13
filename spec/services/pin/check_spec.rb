describe 'pin check service' do
  before do
    stub_send_sms_request
  end

  it 'delete pin if more than three attempts' do
    id = generate_number
    Pin::Create.call generate_pin_params(id, 3)
    items = []

    6.times do
      Pin::Check.call('test_app_key', id, generate_number)

      items << Pin.get_value_by(id)
    end

    expect(items.compact.count).to eq(3)
  end
end
