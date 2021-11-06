# frozen_string_literal: true

module UserSessions
  class CreateService
    prepend BasicService

    param :gid
    param :user_gid

    attr_reader :session, :user

    def call
      @user = ::User.find(gid: @user_gid)
      return fail_t!(:user_not_found) if @user.blank?

      @session = UserSession.new(gid: @gid)

      @session.valid? ? @user.add_session(@session) : fail!(@session.errors)
    end

    private

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'service.user_sessions.create_service'))
    end
  end
end
