# frozen_string_literal: true

module Balances
  class WithdrawService
    prepend BasicService

    param :user_id
    param :task_cost

    def call
      @user = User.first(id: @user_id)
      return fail!(I18n.t(:user_not_found, scope: 'errors')) if @user.blank?

      Sequel.connect(Settings.db.to_hash) do |db|
        db.transaction do
          @user.update(balance: @user.balance - 10)
        end
      end
      produce_event
    end

    private

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.accounting,
        event_name: 'Withdraw',
        event_version: event_version,
        event_type: 'BE',
        payload: {
          user_gid: @user.gid,
          amount: @task_cost,
        },
        type: 'accounting.Withdraw'
      )
    end

    def event_version
      1
    end
  end
end
