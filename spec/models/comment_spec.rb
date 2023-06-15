require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) do
    User.create(name: 'Jane Smith', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                bio: 'Teacher from Mexico.')
  end
  let!(:post) do
    Post.create(title: 'Test Post', text: 'Lorem ipsum', comments_counter: 0, likes_counter: 0, author: user)
  end

  describe 'associations' do
    it 'belongs to an author' do
      comment = Comment.create(text: 'this is a comment', author: user)
      expect(comment.author).to eq(user)
    end

    it 'belongs to a post' do
      comment = Comment.create(text: 'this is a comment', posts: post)
      expect(comment.posts).to eq(post)
    end
  end

  describe 'callbacks' do
    it 'updates the comments counter on the post after saving' do
      expect do
        Comment.create(posts: post, author: user, text: 'This is a comment')
      end.to change { post.reload.comments_counter }.from(0).to(1)
    end
  end
end
