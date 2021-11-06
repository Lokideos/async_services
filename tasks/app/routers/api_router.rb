# frozen_string_literal: true

class ApiRouter < AbstractApiRouter
  plugin :multi_run
  plugin :error_handler
  include Errors
  include Validations
  include ApiErrors
  include Auth

  route do |r|
    r.multi_run
    r.root do
      %w(docs will be here)
    end
  end
end
