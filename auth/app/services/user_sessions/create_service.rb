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
      @session = @user.sessions.first

      if @session.blank?
        @session = UserSession.new(user: @user)

        if @session.valid?
          @user.add_session(@session)
          produce_event
        else
          fail!(@session.errors)
        end
      end
    end

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'service.user_sessions.create_service'))
    end

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.authentication,
        event_name: 'UserAuthenticated',
        event_version: event_version,
        event_type: 'CUD',
        payload: {
          gid: @session.gid,
          user_gid: @user.gid,
        },
        type: 'auth.UserAuthenticated',
      )
    end

    def event_version
      1
    end
  end
end
