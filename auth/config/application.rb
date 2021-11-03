# frozen_string_literal: true

class Application < Roda
  def self.root
    File.expand_path('..', __dir__)
  end

  plugin :public, root: "#{Application.root}/spa/build"
  plugin :type_routing
  plugin :environments
  plugin :json_parser
  plugin(:not_found) { not_found_response }
  include Errors
  include Validations
  include ApiErrors
  include Auth

  route do |r|
    r.public
    r.get do
      r.html { IO.read("#{Application.root}/spa/build/index.html") }
    end

    r.on 'api' do
      r.on 'v1' do
        r.on 'auth' do
          r.on 'signup' do
            r.post do
              user_params = validate_with!(UserParamsContract, params).to_h.values
              result = Users::CreateService.call(*user_params)
              response['Content-Type'] = 'application/json'

              if result.success?
                serializer = UserSerializer.new(result.user)

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

        r.on 'me' do
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
    end
  end

  private

  def params
    request.params
  end
end
