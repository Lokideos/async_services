# frozen_string_literal: true

class RolesRoute < AbstractRoute
  include Auth

  route do |r|
    r.patch 'update' do
      role_params = validate_with!(RoleParamsContract, params).to_h.values + [extracted_token['gid']]
      result = Roles::ChangeService.call(*role_params)
      response['Content-Type'] = 'application/json'

      if result.success?
        serializer = UserSerializer.new(result.user)

        response.status = 200
        serializer.serializable_hash.to_json
      else
        response.status = 422
        error_response(result.user || result.errors)
      end
    end
  end
end
