describe 'pin create service' do
  it 'create counter' do
    id = generate_number

    Pin::Create.call generate_pin_params(id)

    counter = Counter.get_value_by id

    expect(counter).to eq('100')
  end

  it 'fail if msg invalid' do
    id = generate_number
    params = generate_pin_params(id).merge(message: 'Invalid :(')

    service = Pin::Create.call params

    expect(service.errors.include?('invalid_msg')).to eq(true)
  end
end
