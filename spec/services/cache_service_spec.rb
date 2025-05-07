require 'spec_helper'

describe CacheService do
  let(:redis) { Redis.new(url: ENV['REDIS_URL']) }
  let(:cache) { CacheService.new }
  let(:user) { User.create(username: 'bob') }
  let(:message) { Message.create(user: user, content: 'Cache test', created_at: Time.now) }

  before { redis.flushdb }

  it 'guarda y recupera un mensaje en la cache' do
    cache.cache_message(message)
    raw = redis.get("message:#{message.id}")
    expect(raw).not_to be_nil
    parsed = JSON.parse(raw)
    expect(parsed['content']).to eq('Cache test')
  end

  it 'guarda y recupera una página de timeline' do
    cache.cache_timeline(user.id, 1, [message])
    result = cache.get_timeline(user.id, 1)
    expect(result.first['content']).to eq('Cache test')
  end
end
