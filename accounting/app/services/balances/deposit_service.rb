# frozen_string_literal: true

module Balances
  class DepositService
    prepend BasicService

    param :user_id
    param :task_compensation

    def call
      @user = User.first(id: @user_id)
      return fail!(I18n.t(:user_not_found, scope: 'errors')) if @user.blank?

      Sequel.connect(Settings.db.to_hash) do |db|
        db.transaction do
          @user.update(balance: @user.balance + @task_compensation)
        end
      end
      produce_event
    end

    private

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.accounting,
        event_name: 'Deposit',
        event_version: event_version,
        event_type: 'BE',
        payload: {
          user_gid: @user.gid,
          amount: @task_cost,
        },
        type: 'accounting.Deposit'
      )
    end

    def event_version
      1
    end
  end
end
