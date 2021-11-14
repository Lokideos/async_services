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
      produce_event
    end

    private

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.authentication,
        event_name: 'UserLoggedOut',
        event_version: event_version,
        event_type: 'CUD',
        payload: {
          gid: @session.gid,
        },
        type: 'auth.UserLoggedOut'
      )
    end

    def session
      @session ||= UserSession.find(gid: @gid)
    end

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'service.user_sessions.destroy_service'))
    end

    def event_version
      1
    end
  end
end
