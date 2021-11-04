# frozen_string_literal: true

class ProfileRoute < AbstractRoute
  include Auth

  route do |r|
    r.get do
      result = Users::FetchService.call(extracted_token['gid'])
      response['Content-Type'] = 'application/json'

      if result.success?
        serializer = UserSerializer.new(result.user)

        response.status = 200
        serializer.serializable_hash.to_json
      else
        response.status = 403
        error_response(result.errors)
      end
    end
  end
end
