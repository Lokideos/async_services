# frozen_string_literal: true

class SessionParamsContract < Dry::Validation::Contract
  params do
    required(:email).filled(:string)
    required(:password).filled(:string)
  end
end
