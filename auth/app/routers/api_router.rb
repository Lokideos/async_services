# frozen_string_literal: true

class ApiRouter < AbstractApiRouter
  plugin :multi_run
  plugin :error_handler
  include Errors
  include Validations
  include ApiErrors
  include Auth

  run 'v1/auth', AuthRoute
  run 'v1/profile', ProfileRoute
  run 'v1/users', UsersRoute
  run 'v1/roles', RolesRoute

  route do |r|
    r.multi_run
    r.root do
      %w(auth profile users roles)
    end
  end
end
