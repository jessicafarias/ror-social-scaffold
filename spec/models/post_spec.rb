require 'rails_helper'

RSpec.describe Post, type: :model do
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

  context "Validations" do
    it 'Invalid Post due no user_id atributes' do
      expect(Post.new(content: 'some text', user_id: 1).valid?).to be false
    end
  end
end
