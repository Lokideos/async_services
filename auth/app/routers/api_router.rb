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

  route do |r|
    r.multi_run
    r.root do
      %w[docs will be here one day]
    end
  end
end
