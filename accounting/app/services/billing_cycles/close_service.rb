# frozen_string_literal: true

module BillingCycles
  class CloseService
    prepend BasicService

    def call
      User.all.each do |user|
        user_gid = user.gid
        user_balance = user.balance
        p "Background job sent email to user #{user_gid}"
        Payments::CreateService.call(user.id, user_balance)
        Balances::NullifyService(user.id)
      end
      produce_event
    end

    private

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.billing,
        event_name: 'PeriodClosed',
        event_version: event_version,
        event_type: 'BE',
        payload: {},
        type: 'billing.PeriodClosed'
      )
    end

    def event_version
      1
    end
  end
end
