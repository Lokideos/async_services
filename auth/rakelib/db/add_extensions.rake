# frozen_string_literal: true

require 'sequel/core'

namespace :db do
  desc 'Add extensions to the database'
  task add_extensions: :settings do
    Sequel.connect(Settings.db.to_hash) do |db|
      db.execute "CREATE EXTENSION citext;"
    end
  end
end
