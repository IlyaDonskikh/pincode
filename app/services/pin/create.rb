class Pin::Create < Service::Base
  attr_accessor :id, :code, :errors

  def initialize(attrs)
    @app_key = attrs[:app_key]
    @id = attrs[:id]
    @message = attrs[:message]
    @phone = attrs[:phone]
    @expire = attrs[:expire]
    @attempts = attrs[:attempts]
    @code = generate_code

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
      check_message
    end

    def check_app_key
      correct_app_key = Pincode::Application.settings.app_key

      return if correct_app_key == @app_key

      errors << 'invalid_app_key'
    end

    def check_message
      return if @message.match('{{pin}}')

      errors << 'invalid_msg'
    end

    def generate_code
      (9999 * rand).to_i
    end

    def create_bruteforce_protection
      Counter.create(key: id, value: @attempts, expire: @expire)
    end

    def send_code
      msg = generate_message

      p msg unless ENV['RACK_ENV']
    end

    def generate_message
      @message.gsub('{{pin}}', @code.to_s)
    end
end
