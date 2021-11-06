# frozen_string_literal: true

class AuthRoute < AbstractRoute
  include Auth

  route do |r|
    r.on 'signup' do
      r.post do
        user_params = validate_with!(UserParamsContract, params).to_h.values
        result = Users::CreateService.call(*user_params)
        response['Content-Type'] = 'application/json'

        if result.success?
          login_result = UserSessions::CreateService.call(user_params[1], user_params[2])
          token = JwtEncoder.encode(gid: login_result.session.gid)
          options = { meta: { token: token } }
          serializer = UserSerializer.new(result.user, options)

          response.status = 201
          serializer.serializable_hash.to_json
        else
          response.status = 422
          error_response(result.user)
        end
      end
    end

    r.post 'signin' do
      session_params = validate_with!(SessionParamsContract, params).to_h.values
      result = UserSessions::CreateService.call(*session_params)
      response['Content-Type'] = 'application/json'

      if result.success?
        token = JwtEncoder.encode(gid: result.session.gid)
        options = { meta: { token: token } }
        serializer = UserSerializer.new(result.user, options)

        response.status = 201
        serializer.serializable_hash.to_json
      else
        response.status = 401
        error_response(result.session || result.errors)
      end
    end
  end
end
