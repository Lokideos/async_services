# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.

# Create users

time = Time.now
user_data = [
  [SecureRandom.uuid, 'admin', time, time],
  [SecureRandom.uuid, 'manager', time, time],
  [SecureRandom.uuid, 'developer', time, time],
  [SecureRandom.uuid, 'developer', time, time],
]

User.import(%i(gid role created_at updated_at), user_data)

sessions_data = [
  [SecureRandom.uuid, User.first&.id, time, time],
]

UserSession.import(%i(gid user_id created_at updated_at), sessions_data)

task_data = [
  [
    'Add Title',
    'Add Title to the page',
    'in_progress',
    SecureRandom.uuid,
    User.find(role: 'developer')&.id,
    time,
    time,
  ],
  [
    'Add Goal',
    'Add Goal to the page',
    'in_progress',
    SecureRandom.uuid,
    User.find(role: 'developer')&.id,
    time,
    time,
  ],
  [
    'Add Plus',
    'Add Plus to the page',
    'done',
    SecureRandom.uuid,
    User.find(role: 'developer')&.id,
    time,
    time,
  ],
]

Task.import(%i(title description status gid user_id created_at updated_at), task_data)
