class Friendship < ApplicationRecord
  # De preferencia especificar a que foreign_key pertenece
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
end
