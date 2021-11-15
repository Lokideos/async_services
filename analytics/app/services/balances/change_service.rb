# frozen_string_literal: true

module Balances
  class ChangeService
    prepend BasicService

    param :user_gid
    param :balance_amount

    def call
      @user = User.first(gid: @user_gid)
      return fail!(I18n.t(:user_not_found, scope: 'errors')) if @user.blank?

      @user.update(balance: @balance_amount)
    end
  end
end
