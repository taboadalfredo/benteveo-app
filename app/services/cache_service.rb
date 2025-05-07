require 'redis'
require 'json'

class CacheService
  def initialize
    @redis = Redis.new(url: ENV['REDIS_URL'])
  end

  def cache_message(message)
    # Guarda el mensaje individualmente
    @redis.set("message:#{message.id}", message.to_json)

    # Lista LRU de mensajes por usuario
    @redis.lpush("user:#{message.user_id}:messages", message.id)
    @redis.ltrim("user:#{message.user_id}:messages", 0, 99)  # Guarda solo los 100 últimos
  end

  def cache_timeline(user_id, page, messages)
    key = "timeline:#{user_id}:page:#{page}"
    @redis.set(key, messages.to_json)
  end

  def get_timeline(user_id, page)
    key = "timeline:#{user_id}:page:#{page}"
    raw = @redis.get(key)
    raw ? JSON.parse(raw) : nil
  end
end
