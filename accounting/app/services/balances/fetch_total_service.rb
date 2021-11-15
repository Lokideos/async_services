# frozen_string_literal: true

module Balances
  class FetchTotalService
    prepend BasicService

    param :session_gid

    attr_reader :total_balance

    def call
      if @session_gid.blank? || session.blank?
        return fail!(I18n.t(:unauthenticated, scope: 'errors'))
      end

      @user = session.user
      return fail!(I18n.t(:user_not_found, scope: 'errors')) if @user.blank?

      return fail!(I18n.t(:unauthorized, scope: 'errors')) unless %w(admin manager).include? @user.role

      @total_balance = User.balances_total
    end

    private

    def session
      @session ||= UserSession.find(gid: @session_gid)
    end
  end
end
