describe 'pin create service' do
  it 'create counter' do
    id = generate_number

    Pin::Create.call('test_app_key', id, nil)

    counter = Counter.get_value_by id

    expect(counter).to eq('100')
  end
end
