class Pin::Create < Service::Base
  attr_accessor :id, :code, :errors

  def initialize(app_key, id, phone, expire = 120, attempts = 100)
    @app_key = app_key
    @id = id
    @phone = phone
    @code = generate_code
    @expire = expire # seconds
    @attempts = attempts
    @errors = []
  end

  def call
    verify!

    if errors.empty?
      Pin.create(key: id, value: code, expire: @expire)
      create_bruteforce_protection
      send_code
    end

    self
  end

  private

    def verify!
      check_app_key
    end

    def check_app_key
      correct_app_key = Pincode::Application.settings.app_key

      return if correct_app_key == @app_key

      errors << 'invalid_app_key'
    end

    def generate_code
      (9999 * rand).to_i
    end

    def create_bruteforce_protection
      Counter.create(key: id, value: @attempts, expire: @expire)
    end

    def send_code
      # Send sms to phone number
    end
end
