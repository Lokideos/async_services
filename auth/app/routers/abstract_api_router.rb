# frozen_string_literal: true

class AbstractApiRouter < Roda
  plugin :all_verbs
  plugin :error_handler
  plugin :json
  plugin :json_parser
  plugin :halt
  plugin :slash_path_empty

  private

  def params
    request.params
  end
end
