# frozen_string_literal: true

class TaskCostParamsContract < Dry::Validation::Contract
  params do
    required(:date).filled(:string)
  end
end
