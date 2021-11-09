# frozen_string_literal: true

module Validations
  class InvalidParams < StandardError; end

  def validate_with!(validation, values)
    result = validate_with(validation, values)
    raise InvalidParams if result.failure?

    result
  end

  def validate_with(validation, values)
    contract = validation.new
    contract.call(values)
  end
end
