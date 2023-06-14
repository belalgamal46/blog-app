require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:comments).with_foreign_key('author_id') }
    it { should have_many(:posts).with_foreign_key('author_id') }
    it { should have_many(:likes).with_foreign_key('author_id') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:posts_counter).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe '#latest_three_posts' do
    let(:user) do
      User.create(name: 'Jane Smith', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                  bio: 'Teacher from Mexico.')
    end

    let!(:post1) do
      Post.create(title: 'Post 1', text: 'This is post 1', author: user, comments_counter: 0, likes_counter: 0,
                  created_at: 1.days.ago)
    end

    let!(:post2) do
      Post.create(title: 'Post 2', text: 'This is post 2', author: user, comments_counter: 0, likes_counter: 0,
                  created_at: 2.days.ago)
    end

    let!(:post3) do
      Post.create(title: 'Post 3', text: 'This is post 3', author: user, comments_counter: 0, likes_counter: 0,
                  created_at: 3.days.ago)
    end

    let!(:post4) do
      Post.create(title: 'Post 4', text: 'This is post 4', author: user, comments_counter: 0, likes_counter: 0,
                  created_at: 4.days.ago)
    end

    it 'returns the latest three posts' do
      expect(user.latest_three_posts).to eq([post1, post2, post3])
    end

    it 'does not return posts older than the latest three' do
      expect(user.latest_three_posts).not_to include(post4)
    end
  end
end
