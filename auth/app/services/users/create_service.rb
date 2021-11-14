# frozen_string_literal: true

module Users
  class CreateService
    prepend BasicService

    param :name
    param :email
    param :role
    param :password

    attr_reader :user

    def call
      @user = ::User.new(name: @name, email: @email, role: @role, password: @password)

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
        event_name: 'AccountCreated',
        event_version: event_version,
        event_type: 'CUD',
        payload: {
          gid: @user.gid,
          role: @user.role,
        },
        type: 'auth.AccountCreated',
      )
    end

    def event_version
      1
    end
  end
end
