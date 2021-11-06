# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.

# Create users

time = Time.now
user_data = [
  [SecureRandom.uuid, 'admin', time, time],
  [SecureRandom.uuid, 'manager', time, time],
  [SecureRandom.uuid, 'developer', time, time]
]

User.import(%i(gid role created_at updated_at), user_data)
