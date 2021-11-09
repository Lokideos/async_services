# frozen_string_literal: true

class TasksRoute < AbstractRoute
  include Auth

  route do |r|
    r.get 'me' do
      result = Tasks::FetchForUserService.call(extracted_token['gid'])
      response['Content-Type'] = 'application/json'

      if result.success?
        serializer = TaskSerializer.new(result.tasks)

        response.status = 200
        serializer.serializable_hash.to_json
      else
        response.status = 422
        error_response(result.errors)
      end
    end

    r.get do
      result = Tasks::FetchAllService.call(extracted_token['gid'])
      response['Content-Type'] = 'application/json'

      if result.success?
        serializer = TaskSerializer.new(result.tasks)

        response.status = 200
        serializer.serializable_hash.to_json
      else
        response.status = 422
        error_response(result.errors)
      end
    end

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

    r.post 'assign' do
      result = Tasks::AssignService.call(extracted_token['gid'])
      response['Content-Type'] = 'application/json'

      if result.success?
        response.status = 200
        {}.to_json
      else
        response.status = 422
        error_response(result.errors)
      end
    end

    r.post 'complete' do
      task_params = validate_with!(TaskCompleteParamsContract, params).to_h.values + [extracted_token['gid']]
      result = Tasks::CompleteService.call(*task_params)
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
