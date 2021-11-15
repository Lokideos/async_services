# frozen_string_literal: true

module Balances
  class FetchForUserService
    prepend BasicService

    param :session_gid

    attr_reader :user_balance

    def call
      if @session_gid.blank? || session.blank?
        return fail!(I18n.t(:unauthenticated, scope: 'errors'))
      end

      @user = session.user
      return fail!(I18n.t(:user_not_found, scope: 'errors')) if @user.blank?

      @user_balance = User.user_balance(@user.id)
    end

    private

    def session
      @session ||= UserSession.find(gid: @session_gid)
    end
  end
end
