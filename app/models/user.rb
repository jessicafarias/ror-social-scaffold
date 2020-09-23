class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  # Confirmed Friendships
  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    friends_array.concat(inverse_friendships.map { |friendship| friendship.user if friendship.confirmed })
    friends_array.compact
  end

  # Users who have to confirm friend request
  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  end

  # To Confirm a Friend (User)
  def confirm_friend(user)
    confirmed_friend = inverse_friendships.find { |friendship| friendship.user == user }
    confirmed_friend.confirmed = true
    #return false unless confirm_friend.user_id == user.id 
    #Si eres el que envio la invitacion no puedes confirmarlo
    confirmed_friend.save 
    #true retorna verdadero si se sobreescribe
  end

  # To Confirm if it's an existing Friend
  def friend?(user)
    friends.include?(user)
  end

  def requested_friend?(user)
    pending_friends.include?(user)
  end

end
