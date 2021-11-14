# frozen_string_literal: true

require 'sequel/core'

namespace :db do
  desc 'Run database migrations'
  task :migrate, %i(version) => :settings do |t, args|
    Sequel.extension :migration

    Sequel.connect(Settings.db.to_hash) do |db|
      migrations = File.expand_path('../../db/migrations', __dir__)
      version = args.version.to_i if args.version

      Sequel::Migrator.run(db, migrations, target: version)
    end
    Rake::Task['db:schema'].execute
    Rake::Task['db:version'].execute
  end
end
