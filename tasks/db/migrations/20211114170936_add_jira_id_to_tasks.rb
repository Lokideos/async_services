# frozen_string_literal: true

Sequel.migration do
  up do
    add_column :tasks, :jira_id, 'character varying'
  end

  down do
    drop_column :tasks, :jira_id
  end
end
