class Pin::Create < Service::Base
  attr_accessor :id, :code, :errors

  def initialize(id, phone, expire = 120, attempts = 100)
    @id = id
    @phone = phone
    @code = generate_code
    @expire = expire # seconds
    @attempts = attempts
    @errors = []
  end

  def call
    Pin.create(key: id, value: code, expire: @expire)
    create_bruteforce_protection
    send_code

    self
  end

  private

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
