# frozen_string_literal: true

class BalancesRoute < AbstractRoute
  include Auth

  route do |r|
    r.get 'me' do
      result = Balances::FetchForUserService.call(extracted_token['gid'])
      response['Content-Type'] = 'application/json'

      if result.success?
        balance_serializer = BalanceSerializer.new(result.user_balance).serializable_hash
        transaction_serializer = TransactionSerializer.new(result.user_transactions).serializable_hash
        response_structure = balance_serializer.merge(transactions: transaction_serializer)

        response.status = 200
        response_structure.to_json
      else
        response.status = 422
        error_response(result.errors)
      end
    end

    r.get do
      result = Balances::FetchAllService.call(extracted_token['gid'])
      response['Content-Type'] = 'application/json'

      if result.success?
        serializer = BalanceSerializer.new(result.user_balances)

        response.status = 200
        serializer.serializable_hash.to_json
      else
        response.status = 422
        error_response(result.errors)
      end
    end
  end
end
