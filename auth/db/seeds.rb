# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.

users = []
user_data = [
  { name: 'Bob', email: 'bob@example.com', role: 'admin', password: 'givemeatoken' },
  { name: 'Eva', email: 'eva@example.com', role: 'manager', password: 'givemeatoken' },
  {
    name: 'Alice', email: 'alice@example.com', role: 'developer',
    password: 'givemeatoken',
  },
  { name: 'test', email: 'test@test.com', role: 'admin', password: '123' },
]
user_data.each do |user|
  users << User.create(user)
end

# Create user sessions
session_data = [{ user: users[0] }, { user: users[1] }]
session_data.each do |session|
  UserSession.create(session)
end
