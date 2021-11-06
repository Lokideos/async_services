# frozen_string_literal: true

class TasksRoute < AbstractRoute
  include Auth

  route do |r|
    r.post 'create' do
      task_params = validate_with!(TaskParamsContract, params).to_h.values + [extracted_token['gid']]
      result = Tasks::CreateService.call(*task_params)
      response['Content-Type'] = 'application/json'

      if result.success?
        serializer = TaskSerializer.new(result.task)

        response.status = 201
        serializer.serializable_hash.to_json
      else
        response.status = 422
        error_response(result.task&.errors || result.errors)
      end
    end
  end
end
