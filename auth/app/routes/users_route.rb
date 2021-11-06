# frozen_string_literal: true

class UsersRoute < AbstractRoute
  include Auth

  route do |r|
    r.get do
      result = Users::FetchAllService.call(extracted_token['gid'])
      response['Content-Type'] = 'application/json'

      if result.success?
        serializer = UserSerializer.new(result.users)

        response.status = 200
        serializer.serializable_hash.to_json
      else
        response.status = 403
        error_response(result.errors)
      end
    end

    r.delete 'destroy' do
      user_params = validate_with!(UserDestroyParamsContract, params).to_h.values + [extracted_token['gid']]
      result = Users::DestroyService.call(*user_params)
      response['Content-Type'] = 'application/json'

      if result.success?
        response.status = 200
        {}.to_json
      else
        response.status = 422
        error_response(result.errors)
      end
    end
  end
end
