class Pin::Check < Service::Base
  attr_accessor :id, :verification_code, :errors

  def initialize(id, verification_code)
    @id = id
    @verification_code = verification_code
    @errors = []
  end

  def call
    verify!

    Pin.delete(id) if @errors.empty?

    self
  end

  private

    def verify!
      check_code_present
      check_id_present
      check_bruteforce
      check_code_valid
    end

    def check_code_present
      return if verification_code

      errors << 'code_not_defined'
    end

    def check_id_present
      return if id

      errors << 'id_not_defined'
    end

    def check_bruteforce
      counter = Counter.get_value_by(id)
      counter && count = Counter.decr(id)

      return if counter && count >= 0

      Counter.delete id
      Pin.delete id
      errors << 'bruteforce_protection'
    end

    def check_code_valid
      code = Pin.get_value_by(id)

      return if code && code == verification_code

      errors << 'code_not_valid'
    end
end
