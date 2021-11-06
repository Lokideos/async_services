# frozen_string_literal: true

class TaskCompleteParamsContract < Dry::Validation::Contract
  params do
    required(:task_id).filled(:integer)
  end
end
