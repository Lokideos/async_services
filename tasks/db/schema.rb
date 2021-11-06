Sequel.migration do
  change do
    create_table(:schema_migrations) do
      column :filename, "text", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:users) do
      primary_key :id, :type=>:Bignum
      column :gid, "uuid", :null=>false
      column :role, "roles_enum", :null=>false
      column :created_at, "timestamp(6) without time zone", :null=>false
      column :updated_at, "timestamp(6) without time zone", :null=>false
    end
    
    create_table(:tasks) do
      primary_key :id, :type=>:Bignum
      column :title, "character varying", :null=>false
      column :description, "character varying", :null=>false
      column :status, "task_status_types_enum", :default=>Sequel::LiteralString.new("'in_progress'::task_status_types_enum"), :null=>false
      column :gid, "uuid", :null=>false
      foreign_key :user_id, :users, :type=>"bigint", :null=>false, :key=>[:id]
      column :created_at, "timestamp(6) without time zone", :null=>false
      column :updated_at, "timestamp(6) without time zone", :null=>false
    end
    
    create_table(:user_sessions) do
      primary_key :id, :type=>:Bignum
      column :gid, "uuid", :null=>false
      foreign_key :user_id, :users, :type=>"bigint", :null=>false, :key=>[:id]
      column :created_at, "timestamp(6) without time zone", :null=>false
      column :updated_at, "timestamp(6) without time zone", :null=>false
      
      index [:gid], :name=>:index_user_sessions_on_gid
      index [:user_id], :name=>:index_user_sessions_on_user_id
    end
  end
end
