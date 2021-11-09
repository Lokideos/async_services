# frozen_string_literal: true

Sequel.migration do
  up do
    Sequel.connect(Settings.db.to_hash) do |db|
      db.execute "CREATE EXTENSION citext;"
    end
  end

  down do
    Sequel.connect(Settings.db.to_hash) do |db|
      db.execute "DROP EXTENSION citext;"
    end
  end
end
