# frozen_string_literal: true

class UserDestroyParamsContract < Dry::Validation::Contract
  params do
    required(:id).filled(:integer)
  end
end
