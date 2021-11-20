# frozen_string_literal: true

module Billing
  class CloseCycleWorker
    include Sidekiq::Worker
    sidekiq_options queue: :billing_cycles, retry: 2, backtrace: 20

    def perform
      BillingCycles::CloseService.call
    end
  end
end
