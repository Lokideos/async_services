# frozen_string_literal: true

class BalanceSerializer
  include JSONAPI::Serializer

  set_type :balance
  attributes :id, :balance
end
