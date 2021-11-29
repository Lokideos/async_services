# frozen_string_literal: true

module Payments
  class CreateService
    prepend BasicService

    param :user_id
    param :amount

    attr_reader :user

    def call
      @user = ::User.find(id: @user_id)
      return fail_t!(:user_not_found) if @user.blank?

      p "#{@amount} money were paid to #{@user.gid} user!"
      produce_event
    end

    private

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'service.payments.create_service'))
    end

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.billing,
        event_name: 'PaymentProcessed',
        event_version: event_version,
        event_type: 'BE',
        payload: {
          user_gid: @user.gid,
          amount: @amount,
        },
        type: 'billing.PaymentProcessed'
      )
    end

    def event_version
      1
    end
  end
end
