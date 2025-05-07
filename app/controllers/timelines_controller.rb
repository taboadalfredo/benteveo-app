require_relative '../services/cache_service'
require_relative '../models/user'
require_relative '../models/message'
require_relative '../models/follow'

require 'sinatra/base'

class TimelinesController < Sinatra::Base
  get '/timeline/:username' do
    user = User.find_by(username: params[:username])
    halt 404 unless user

    page = (params[:page] || 1).to_i
    cache = CacheService.new
    cached_page = cache.get_timeline(user.id, page)

    # return cached_page.to_json if cached_page

    followed_ids = Follow.where(follower_id: user.id).pluck(:followed_id)
    messages = Message.where(user_id: followed_ids)
                      .order(created_at: :desc)
                      .limit(20)
                      .offset((page - 1) * 20)

    cache.cache_timeline(user.id, page, messages)

    # Precarga de siguiente página
    next_messages = Message.where(user_id: followed_ids)
                           .order(created_at: :desc)
                           .limit(20)
                           .offset(page * 20)
    cache.cache_timeline(user.id, page + 1, next_messages)

    messages.to_json
  end
end