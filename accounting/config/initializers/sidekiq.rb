# frozen_string_literal: true

redis_host = Settings.redis.host
redis_port = Settings.redis.port
redis_db = Settings.redis.sidekiq_db
redis_url = "redis://#{redis_host}:#{redis_port}/#{redis_db}"

Sidekiq.options[:dead_max_jobs] = 1_000
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, db: redis_db, network_timeout: 15 }
end
Sidekiq.configure_server do |config|
  config.redis = { url: redis_url, db: redis_db, network_timeout: 15 }
end
