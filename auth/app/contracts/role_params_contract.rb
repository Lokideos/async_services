# frozen_string_literal: true

class RoleParamsContract < Dry::Validation::Contract
  params do
    required(:gid).filled(:string)
    required(:role).filled(:string)
  end
end
