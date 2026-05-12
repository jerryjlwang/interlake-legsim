require "uri"

def railway_redis_url
  host = ENV["REDISHOST"].presence
  return unless host

  port = ENV["REDISPORT"].presence || "6379"
  user = ENV["REDISUSER"].presence
  password = ENV["REDISPASSWORD"].presence
  auth = if user && password
    "#{URI.encode_www_form_component(user)}:#{URI.encode_www_form_component(password)}@"
  elsif password
    ":#{URI.encode_www_form_component(password)}@"
  elsif user
    "#{URI.encode_www_form_component(user)}@"
  end

  "redis://#{auth}#{host}:#{port}"
end

redis_url = ENV["REDIS_URL"].presence || railway_redis_url

if redis_url.blank?
  raise "REDIS_URL is required in production" if Rails.env.production?

  redis_url = "redis://localhost:6379/0"
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
