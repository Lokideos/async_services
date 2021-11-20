# frozen_string_literal: true

class TransactionSerializer
  include JSONAPI::Serializer

  set_type :transaction
  attributes :id, :type, :amount, :created_at
end
