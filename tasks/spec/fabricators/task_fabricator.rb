# frozen_string_literal: true

Fabricator(:task) do
  title { sequence { |n| "title_#{n}" } }
  description { sequence { |n| "description_#{n}" } }
  gid { SecureRandom.uuid }
  user
end
