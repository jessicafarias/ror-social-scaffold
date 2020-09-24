require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context '#Associations' do
    it 'Friendship has a foreign_key from user id' do
      association = Friendship.reflect_on_association(:user)
      expect(association.foreign_key).to eq('user_id')
    end

    it 'Friendship belongs to user' do
      association = Friendship.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'Friendship belongs to friend' do
      association = Friendship.reflect_on_association(:friend)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'Friendship has a foreign_key from friend table' do
      association = Friendship.reflect_on_association(:friend)
      expect(association.foreign_key).to eq('friend_id')
    end
  end
end
