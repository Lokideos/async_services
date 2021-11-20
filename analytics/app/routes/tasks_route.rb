# frozen_string_literal: true

class TasksRoute < AbstractRoute
  include Auth

  route do |r|
    r.post 'cost' do
      task_params = validate_with!(TaskCostParamsContract, params).to_h.values + [extracted_token['gid']]
      result = Tasks::CalculateCostService.call(*task_params)
      response['Content-Type'] = 'application/json'

      if result.success?
        serializer = TaskSerializer.new(result.task)

        response.status = 200
        serializer.serializable_hash.to_json
      else
        response.status = 422
        error_response(result.errors)
      end
    end
  end
end
