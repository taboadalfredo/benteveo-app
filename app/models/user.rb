require 'active_record'

class User < ActiveRecord::Base
  has_many :messages
  has_many :follows, foreign_key: :follower_id
  has_many :followed_users, through: :follows, source: :followed
end
