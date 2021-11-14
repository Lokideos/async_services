# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum
    create_enum(:roles_enum, %w(developer manager admin))

    create_table(:users) do
      primary_key :id, type: :Bignum
      column :gid, 'uuid', null: false
      column :role, 'roles_enum', null: false
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false
    end
  end

  down do
    extension :pg_enum
    drop_table(:users)
    drop_enum(:roles_enum)
  end
end
