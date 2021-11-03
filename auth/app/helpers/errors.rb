# frozen_string_literal: true

module Errors
  def self.included(base)
    base.error do |e|
      case e
      when Sequel::NoMatchingRow
        response['Content-Type'] = 'application/json'
        response.status = 422
        error_response I18n.t(:not_found, scope: 'api.errors')
      when Sequel::UniqueConstraintViolation
        response['Content-Type'] = 'application/json'
        response.status = 422
        error_response I18n.t(:not_unique, scope: 'api.errors')
      when Validations::InvalidParams, KeyError
        response['Content-Type'] = 'application/json'
        response.status = 422
        error_response I18n.t(:missing_parameters, scope: 'api.errors')
      else
        raise
      end
    end
  end
end
