# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum
    create_enum(:task_status_types_enum, %w(bird_in_cage millet_in_bowl))

    create_table(:tasks) do
      primary_key :id, type: :Bignum
      column :gid, 'uuid', null: false
      column :title, 'character varying', null: false
      column :jira_id, 'character varying', null: false
      column :status, 'task_status_types_enum', null: false
      column :cost, 'decimal', null: false
      column :compensation, 'decimal', null: false
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
