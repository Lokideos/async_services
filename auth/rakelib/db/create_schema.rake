# frozen_string_literal: true

namespace :db do
  desc 'Create db schema'
  task schema: :settings do
    schema_location = "db/schema.rb"
    user = Settings.db.to_h[:user]
    password = Settings.db.to_h[:password]
    host = Settings.db.to_h[:host]
    port = Settings.db.to_h[:port]
    database = Settings.db.to_h[:database]
    db_url = "postgres://#{user}:#{password}@#{host}:#{port}/#{database}"
    system("sequel -D #{db_url} > #{schema_location}")
  end
end
