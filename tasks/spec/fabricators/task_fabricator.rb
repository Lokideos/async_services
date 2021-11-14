# frozen_string_literal: true

Fabricator(:task) do
  title { sequence { |n| "title_#{n}" } }
  jira_id { sequence { |n| "jira_id_#{n}" } }
  description { sequence { |n| "description_#{n}" } }
  status { Task::INITIAL_STATUS }
  gid { SecureRandom.uuid }
  user
end
