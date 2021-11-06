# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum
    create_enum(:roles_enum, %w'developer manager admin')

    add_column :users, :role, 'roles_enum', null: false, default: 'developer'
  end

  down do
    extension :pg_enum
    drop_column :users, :role
    drop_enum(:roles_enum)
  end
end
