# frozen_string_literal: true

Fabricator(:user_session) do
  user
end

Fabricator(:admin_user_session, from: :user_session) do
  user { Fabricate(:user, role: 'admin') }
end
