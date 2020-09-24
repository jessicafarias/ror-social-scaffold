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

  # Users who has SENT a friend request and is waiting for confirmation
  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end

  # Users who RECEIVED a friend request and needs to confirm the request.
  def friend_requests
    inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  end

  # To Confirm a Friend (User) When I want to confirm someone's friendship
  # current_user.confirm_friend(user)
  def confirm_friend(user)
    confirmed_friend = inverse_friendships.find { |friendship| friendship.user == user }
    confirmed_friend
    #confirmed_friend.confirmed = true
    #confirmed_friend.save
  end

  # Determines if The User if the Invitee or the Invited
  def invitee?(user)
    confirmed_friend = inverse_friendships.find { |friendship| friendship.user == user }
    return false if confirmed_friend.nil?

    true
  end

  # To Confirm if it's an existing Friend
  def friend?(user)
    friends.include?(user)
  end

  def requested_friend?(user)
    pending_friends.include?(user)
  end

end
