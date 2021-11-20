# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.

# Create users

time = Time.now
user_data = [
  [SecureRandom.uuid, 'admin', 0, time, time],
  [SecureRandom.uuid, 'manager', 0, time, time],
  [SecureRandom.uuid, 'developer', 0, time, time],
  [SecureRandom.uuid, 'developer', 0, time, time],
]

User.import(%i(gid role balance created_at updated_at), user_data)

# Create sessions

sessions_data = [
  [SecureRandom.uuid, User.first&.id, time, time],
]

UserSession.import(%i(gid user_id created_at updated_at), sessions_data)
