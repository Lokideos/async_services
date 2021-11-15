# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum
    create_enum(:transaction_types_enum, %w(withdraw deposit))

    create_table(:transactions) do
      primary_key :id, type: :Bignum
      column :gid, 'uuid', null: false
      column :type, 'transaction_types_enum', null: false
      column :amount, 'decimal', null: false
      foreign_key :user_id, :users, type: 'bigint', null: false, key: [:id]
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false
    end
  end

  down do
    extension :pg_enum
    drop_table(:transactions)
    drop_enum(:transaction_types_enum)
  end
end
