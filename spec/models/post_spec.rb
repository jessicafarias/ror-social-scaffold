require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { User.create(name: 'name', email: 'email@email.com', password: '123456') }

  context '#Associations' do
    it 'Post does not have association with friendships table' do
      association = Post.reflect_on_association(:friendships)
      expect(association.nil?).to be true
    end

    it 'Post belongs to user' do
      association = Post.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  context 'Validations' do
    it 'Valid Post containing all corresponding atributes' do
      expect(Post.new(user_id: user.id, content: 'some text')).to be_valid
    end

    it 'Invalid Post due to missing user_id atributes' do
      expect(Post.new(content: 'some text')).to_not be_valid
    end

    it 'Invalid Post due to exceeding characters in content' do
      expect(Post.new(content: 'This is a LONG post...'.rjust(1001))).to_not be_valid
    end
  end
end
