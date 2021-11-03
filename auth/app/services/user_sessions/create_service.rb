# frozen_string_literal: true

module UserSessions
  class CreateService
    prepend BasicService

    param :email
    param :password
    option :user, default: proc { User.find(email: @email) }, reader: false

    attr_reader :session, :user

    def call
      validate
      create_session unless failure?
    end

    private

    def validate
      return fail_t!(:unauthorized) unless @user&.authenticate(@password)
    end

    def create_session
      @session = UserSession.new(user: @user)

      @session.valid? ? @user.add_session(@session) : fail!(@session.errors)
    end

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'service.user_sessions.create_service'))
    end
  end
end
