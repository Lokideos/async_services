# frozen_string_literal: true

module Tasks
  class CalculateCostService
    prepend BasicService

    param :date
    param :session_gid

    attr_reader :task

    def call
      if @session_gid.blank? || session.blank?
        return fail!(I18n.t(:unauthenticated, scope: 'errors'))
      end

      @user = session.user
      return fail!(I18n.t(:user_not_found, scope: 'errors')) if @user.blank?

      return fail!(I18n.t(:unauthorized, scope: 'errors')) unless %w(admin).include? @user.role

      @task = Task.most_expensive_at_date(@date)
    end

    private

    def session
      @session ||= UserSession.find(gid: @session_gid)
    end
  end
end
