# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum
    create_enum(:task_status_types_enum, %w(done in_progress))

    create_table(:tasks) do
      primary_key :id, type: :Bignum
      column :title, 'character varying', null: false
      column :description, 'character varying', null: false
      column :status, 'task_status_types_enum', null: false, default: 'in_progress'
      column :gid, 'uuid', null: false
      foreign_key :user_id, :users, type: 'bigint', null: false, key: [:id]
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false
    end
  end

  down do
    extension :pg_enum
    drop_table(:tasks)
    drop_enum(:task_status_types_enum)
  end
end
