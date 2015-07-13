require 'smster'

class Pin::Create < Service::Base
  attr_accessor :id, :code, :errors

  def initialize(attrs)
    @app_key = attrs[:app_key]
    @id = attrs[:id]
    @message = attrs[:message]
    @phone = attrs[:phone]
    @expire = attrs[:expire] || 120
    @attempts = attrs[:attempts] || 10
    @sender = attrs[:sender] || {}
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
      check_sender
    end

    def check_app_key
      correct_app_key = Pincode::Application.settings.app_key

      return if correct_app_key == @app_key

      errors << 'invalid_app_key'
    end

    def check_message
      return if @message.to_s.match('{{pin}}')

      errors << 'invalid_msg'
    end

    def check_sender
      return if @sender['geatway']

      errors << 'geatway undefined'
    end

    def generate_code
      (9999 * rand).to_i
    end

    def create_bruteforce_protection
      Counter.create(key: id, value: @attempts, expire: @expire)
    end

    def send_code
      sender_class = generate_sender_class
      sms = sender_class.new(generate_sms_params)

      case ENV['RACK_ENV']
      when nil then puts(sms)
      else sms = sms.send_sms
      end

      errors << 'sms not sent' if sms.status == 3
    end

    def generate_message
      @message.gsub('{{pin}}', @code.to_s)
    end

    def generate_sender_class
      Object.const_get @sender['geatway']
    end

    def generate_sms_params
      @sender.merge!(
        text: generate_message,
        to: @phone
      )

      @sender.delete('geatway')

      @sender
    end
end
