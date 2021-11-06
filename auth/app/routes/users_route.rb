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
  end
end
