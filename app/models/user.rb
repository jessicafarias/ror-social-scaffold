class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :sent_requests, class_name: 'Friendship', foreign_key: 'user_id', dependent: :destroy
  has_many :received_requests, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy

  def accepted_friendships
    sent_requests.where(confirmed: true)
  end

  # Users who has SENT a friend request and is waiting for confirmation
  def pending_request
    sent_requests.where(confirmed: nil)
  end

  # Users who RECEIVED a friend request and needs to confirm the request.
  def pending_accept
    received_requests.where(confirmed: nil)
  end

  # To Confirm a Friend from (User) When I want to confirm someone's friendship
  def confirm_friend(user)
    friendships_unique = pending_accept.where(user_id: user.id).first
    friendships_unique.confirmed = true
    row = Friendship.new(user_id: friendships_unique.friend_id, friend_id: friendships_unique.user_id, confirmed: true)
    row.save
    friendships_unique.save
  end

  def delete_friend(user)
    friend = sent_requests.find { |friendship| friendship.friend == user }
    friend&.destroy
    friend = received_requests.find { |friendship| friendship.user == user }
    friend.destroy
  end

  def invitee?(user)
    received_requests.where(user_id: user, confirmed: nil).any?
  end

  def requested_friend?(user)
    sent_requests.where(friend_id: user, confirmed: nil).any?
  end

  def friend?(params_user)
    received_requests.where(user_id: params_user, confirmed: true).any?
  end
end
