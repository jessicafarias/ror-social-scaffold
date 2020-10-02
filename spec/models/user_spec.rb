require 'rails_helper'

RSpec.describe User, type: :model do
  context '#Associations' do
    it 'User has many sent_requests for friendships' do
      association = User.reflect_on_association(:sent_requests)
      expect(association.macro).to eq(:has_many)
    end

    it 'User has many received_requests for friendships' do
      association = User.reflect_on_association(:received_requests)
      expect(association.macro).to eq(:has_many)
    end

    it 'User has many posts' do
      association = User.reflect_on_association(:posts)
      expect(association.macro).to eq(:has_many)
    end
  end

  context '#Validation' do
    it 'Valid User with all atributes' do
      expect(User.new(name: 'name', email: 'email@email.com', password: '123456')).to be_valid
    end

    it 'Invalid User due to empty name' do
      expect(User.new(name: nil, email: 'email@email.com', password: '123456')).to_not be_valid
    end

    it 'Invalid User due to empty email' do
      expect(User.new(name: 'name', email: nil, password: '123')).to_not be_valid
    end

    it 'Invalid User due to password too short' do
      expect(User.new(name: 'name', email: 'email@email.com', password: '123')).to_not be_valid
    end
  end

  context 'Model methods' do
    user = User.new(name: 'name', email: 'email@email.com', password: '123')
    user2 = User.new(name: 'name', email: 'email@email.com', password: '123')
    it 'User model can get the list of friendships' do
      expect(user.accepted_friendships.class.to_s).to eql('Friendship::ActiveRecord_AssociationRelation')
    end

    it 'User model can get an array of his accepted friendships' do
      expect(user.accepted_friendships.class.to_s).to eql('Friendship::ActiveRecord_AssociationRelation')
    end

    it 'User model can get an array of his pending_friends' do
      expect(user.pending_request.class.to_s).to eql('Friendship::ActiveRecord_AssociationRelation')
    end

    it 'User returns a booelan if user is an invitee or not' do
      expect(user.invitee?(user2)).to eql(false)
    end
  end
end
