# frozen_string_literal: true

class AbstractRoute < Roda
  plugin :all_verbs
  plugin :error_handler
  plugin :json
  plugin :json_parser
  plugin :halt
  plugin :slash_path_empty
  include Errors
  include Validations
  include ApiErrors

  private

  def params
    request.params
  end
end
