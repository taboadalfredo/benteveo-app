require_relative '../models/user'
require_relative '../models/follow'

require 'sinatra/base'

class FollowsController < Sinatra::Base
  post '/follow' do
    payload = JSON.parse(request.body.read)
    follower = User.find_or_create_by(username: payload['follower'])
    followed = User.find_or_create_by(username: payload['followed'])

    Follow.find_or_create_by(follower_id: follower.id, followed_id: followed.id)

    status 204
  end
end
