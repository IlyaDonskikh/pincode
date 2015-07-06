describe 'pin application' do
  it 'create pin' do
    post 'v1/pins/', id: generate_number

    expect(last_response.status).to eq(200)
  end

  it 'create counter' do
    id = generate_number

    p Pincode::Application.settings.app_key

    post 'v1/pins/', id: id

    counter = Counter.get_value_by id

    expect(counter).to eq("100")
  end

  it 'return 403 if code invalid' do
    id = generate_number
    Pin::Create.call(id, nil, 1000)

    get "v1/pins/#{id}/check", code: generate_number

    expect(last_response.status).to eq(403)
  end

  it 'delete pin if more than three attempts' do
    id = generate_number
    items = []
    Pin::Create.call(id, nil, 1000, 3)

    6.times do
      get "v1/pins/#{id}/check", code: generate_number

      items << Pin.get_value_by(id)
    end

    expect(items.compact.count).to eq(3)
  end

  private

    def generate_number
      (9999 * rand).to_i.to_s
    end
end
