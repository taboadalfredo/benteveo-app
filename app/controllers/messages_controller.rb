require_relative '../services/cache_service'
require_relative '../services/event_service'
require_relative '../models/user'
require_relative '../models/message'

require 'sinatra/base'

class MessagesController < Sinatra::Base
  post '/messages' do
    payload = JSON.parse(request.body.read)
    user = User.find_or_create_by(username: payload['username'])
    message = user.messages.create(content: payload['content'], created_at: Time.now)

    CacheService.new.cache_message(message)
    EventService.publish_message_created(message)

    status 201
    message.to_json
  end
end
