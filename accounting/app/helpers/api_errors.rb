# frozen_string_literal: true

module ApiErrors
  def error_response(error_messages)
    errors = case error_messages
             when Sequel::Model
               ErrorSerializer.from_model(error_messages)
             else
               ErrorSerializer.from_messages(error_messages)
             end

    errors.to_json
  end
end
