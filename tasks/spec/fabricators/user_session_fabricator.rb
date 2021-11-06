# frozen_string_literal: true

Fabricator(:user_session) do
  gid { SecureRandom.uuid }
  user
end
