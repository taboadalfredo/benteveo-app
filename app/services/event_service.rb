require 'redis'
require 'json'

class EventService
  CHANNEL = "message_created"

  def self.publish_message_created(message)
    redis = Redis.new(url: ENV['REDIS_URL'])
    redis.publish(CHANNEL, message.to_json)
  end

  def self.subscribe(&block)
    redis = Redis.new(url: ENV['REDIS_URL'])
    Thread.new do
      redis.subscribe(CHANNEL) do |on|
        on.message do |_channel, msg|
          data = JSON.parse(msg)
          block.call(data)
        end
      end
    end
  end
end
