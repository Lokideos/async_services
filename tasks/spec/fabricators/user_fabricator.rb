# frozen_string_literal: true

Fabricator(:user) do
  gid { sequence { |n| "gid_#{n}" } }
  role 'developer'
end
