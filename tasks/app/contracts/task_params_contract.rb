# frozen_string_literal: true

class TaskParamsContract < Dry::Validation::Contract
  params do
    required(:title).filled(:string)
    required(:description).filled(:string)
    required(:user_gid).filled(:string)
  end
end
