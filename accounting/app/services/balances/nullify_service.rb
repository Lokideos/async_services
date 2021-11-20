# frozen_string_literal: true

module Balances
  class NullifyService
    prepend BasicService

    param :user_id

    def call
      @user = User.first(id: @user_id)
      return fail!(I18n.t(:user_not_found, scope: 'errors')) if @user.blank?

      @user.update(balance: 0)
      produce_event
    end

    private

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.accounting,
        event_name: 'Nullify',
        event_version: event_version,
        event_type: 'CUD',
        payload: {
          user_gid: @user.gid,
        },
        type: 'accounting.Nullify'
      )
    end

    def event_version
      1
    end
  end
end
