module Pincode
  class Application < Sinatra::Base
    configure do
      set :app_key, ENV.fetch('APP_KEY', 'test_app_key')
    end

    post '/v1/pins/?' do
      service = Pin::Create.call(params)

      generate_response(service)
    end

    get '/v1/pins/:id/check' do
      service = Pin::Check.call(
        params[:app_key],
        params[:id],
        params[:code]
      )

      generate_response(service)
    end

    private

      def generate_response(service)
        status_code = service.errors.empty? ? 200 : 403

        status status_code
      end
  end
end
