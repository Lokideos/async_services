# frozen_string_literal: true

require 'sequel/core'

# rubocop:disable Airbnb/RiskyActiverecordInvocation
namespace :db do
  desc 'Drop database'
  task drop: :settings do
    CONNECTION_PARAMETERS = %i(adapter host port user password).freeze

    Sequel.connect(Settings.db.to_hash.slice(*CONNECTION_PARAMETERS)) do |db|
      db.execute "DROP DATABASE #{Settings.db.to_hash[:database]}"
    end
  end
end
# rubocop:enable Airbnb/RiskyActiverecordInvocation
