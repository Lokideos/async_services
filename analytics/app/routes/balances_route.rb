# frozen_string_literal: true

class BalancesRoute < AbstractRoute
  include Auth

  route do |r|
    r.get 'negative' do
      result = Balances::FetchAllNegative.call(extracted_token['gid'])
      response['Content-Type'] = 'application/json'

      if result.success?
        balance_serializer = BalanceSerializer.new(result.user_balances)

        response.status = 200
        balance_serializer.serializable_hash.to_json
      else
        response.status = 422
        error_response(result.errors)
      end
    end

    r.get 'total' do
      result = Balances::FetchTotalService.call(extracted_token['gid'])
      response['Content-Type'] = 'application/json'

      if result.success?
        response.status = 200
        { total: result.total_balance }.to_json
      else
        response.status = 422
        error_response(result.errors)
      end
    end
  end
end
