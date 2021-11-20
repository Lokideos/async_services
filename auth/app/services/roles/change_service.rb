# frozen_string_literal: true

module Roles
  class ChangeService
    prepend BasicService

    param :gid
    param :role
    param :session_gid

    attr_reader :user

    def call
      if @session_gid.blank? || session.blank?
        return fail!(I18n.t(:unauthenticated, scope: 'errors'))
      end

      return fail!(I18n.t(:unauthorized, scope: 'errors')) if session.user.role != 'admin'

      @user = User.first(gid: @gid)
      return fail!(I18n.t(:not_found, scope: 'service.roles.change_service')) if @user.blank?

      @user.role = role
      if @user.valid?
        @user.save
        produce_event
      else
        fail!(@user.errors)
      end
    end

    private

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.authentication,
        event_name: 'RoleChanged',
        event_version: event_version,
        event_type: 'BE',
        payload: {
          gid: @user.gid,
          role: role,
        },
        type: 'auth.RoleChanged'
      )
    end

    def event_version
      1
    end

    def session
      @session ||= UserSession.find(gid: @session_gid)
    end
  end
end
