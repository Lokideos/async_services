# frozen_string_literal: true

class UserParamsContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    required(:email).filled(:string)
    required(:password).filled(:string)
  end
end
