# frozen_string_literal: true

namespace :db do
  desc 'Seed data into database'
  task :seed => :settings do
    require_relative '../../config/environment'

    Sequel.connect(Settings.db.to_hash) do |db|
      db.transaction do
        require_relative '../../db/seeds'
      end
    end
  end
end
