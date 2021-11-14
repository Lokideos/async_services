# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum
    create_enum(:task_status_types_full_enum, %w(done in_progress bird_in_cage millet_in_bowl))
    add_column :tasks, :new_status, 'task_status_types_full_enum', null: false, default: 'bird_in_cage'
  end

  down do
    extension :pg_enum
    drop_column :tasks, :new_status
    drop_enum(:task_status_types_full_enum)
  end
end
