# frozen_string_literal: true

Fabricator(:user) do
  gid { SecureRandom.uuid }
  role 'developer'
  balance { 0 }
end
