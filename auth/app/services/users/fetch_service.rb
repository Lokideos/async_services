# frozen_string_literal: true

module Users
  class FetchService
    prepend BasicService

    param :gid

    attr_reader :user

    def call
      if @gid.blank? || session.blank?
        return fail!(I18n.t(:not_found, scope: 'service.users.fetch_service'))
      end

      @user = session.user
    end

    private

    def session
      @session ||= UserSession.find(gid: @gid)
    end
  end
end
