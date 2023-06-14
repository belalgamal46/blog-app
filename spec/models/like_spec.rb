require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) do
    User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                bio: 'Teacher from Mexico.')
  end

  let!(:post) do
    Post.create(title: 'Test Post', text: 'Lorem ipsum', comments_counter: 0, likes_counter: 0, author: user)
  end

  describe 'associations' do
    it 'belongs to an author' do
      like = Like.create(author: user)
      expect(like.author).to eq(user)
    end

    it 'belongs to a post' do
      like = Like.create(posts: post)
      expect(like.posts).to eq(post)
    end
  end

  describe 'callbacks' do
    it 'updates the likes counter on the post after saving' do
      expect do
        Like.create(posts: post, author: user)
      end.to change { post.reload.likes_counter }.from(0).to(1)
    end
  end
end
