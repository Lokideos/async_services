# frozen_string_literal: true

# rubocop:disable Airbnb/RiskyActiverecordInvocation
namespace :cron do
  desc 'Close Billing Cycle'
  task close_billing_cycle: :settings do
    Billing::CloseCycleWorker.perform_async
  end
end
# rubocop:enable Airbnb/RiskyActiverecordInvocation
