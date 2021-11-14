# frozen_string_literal: true

Fabricator(:user_session) do
  gid { SecureRandom.uuid }
  user
end

Fabricator(:admin_user_session, from: :user_session) do
  gid { SecureRandom.uuid }
  user { Fabricate(:user, role: 'admin') }
end
