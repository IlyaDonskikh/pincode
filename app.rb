module Pincode
  class Application < Sinatra::Base
    configure do
      set :app_key, ENV.fetch('APP_KEY', 'test_app_key')
    end

    post '/v1/pins/?' do
      id = params[:id]
      phone = params[:phone]
      expire = params[:expire]

      service = Pin::Create.call(id, phone, expire)

      generate_response(service)
    end

    get '/v1/pins/:id/check' do
      id = params[:id]
      code = params[:code]

      service = Pin::Check.call(id, code)

      generate_response(service)
    end

    private

      def generate_response(service)
        status_code = service.errors.empty? ? 200 : 403

        status status_code
      end
  end
end
