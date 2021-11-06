# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id, type: :Bignum
      column :name, 'character varying', null: false
      column :email, 'citext', null: false
      column :password_digest, 'character varying', null: false
      column :gid, 'uuid', null: false
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false

      index [:name], name: :index_users_on_name, unique: true
      index [:gid], name: :index_users_on_gid, unique: true
    end
  end

  down do
    drop_table(:users)
  end
end
