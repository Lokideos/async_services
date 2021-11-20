# frozen_string_literal: true

module Users
  class DestroyService
    prepend BasicService

    param :id
    param :session_gid

    def call
      if @session_gid.blank? || session.blank?
        return fail!(I18n.t(:unauthenticated, scope: 'errors'))
      end

      return fail!(I18n.t(:unauthorized, scope: 'errors')) if session.user.role != 'admin'

      @user = ::User.find(id: @id)
      return fail!(I18n.t(:not_found, scope: 'service.users.destroy_service')) if @user.blank?

      @user.destroy
      produce_event
    end

    private

    def session
      @session ||= UserSession.find(gid: @session_gid)
    end

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.authentication,
        event_name: 'AccountDeleted',
        event_version: event_version,
        event_type: 'CUD',
        payload: {
          gid: @user.gid,
        },
        type: 'auth.AccountDeleted',
      )
    end

    def event_version
      1
    end
  end
end
