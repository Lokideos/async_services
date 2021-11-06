# frozen_string_literal: true

module UserSessions
  class DestroyService
    prepend BasicService

    param :gid

    def call
      if @gid.blank? || session.blank?
        return fail_t!(:not_found)
      end

      session.destroy
    end

    private

    def session
      @session ||= UserSession.find(gid: @gid)
    end

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'service.user_sessions.destroy_service'))
    end
  end
end