# frozen_string_literal: true

Fabricator(:user) do
  name { sequence { |n| "name_#{n}" } }
  email { sequence { |n| "email_#{n}" } }
  password { sequence { |n| "password_#{n}" } }
  role 'developer'
end
