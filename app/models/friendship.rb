class Friendship < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
  has_many :posts, class_name: 'Post', foreign_key: 'user_id'
end
