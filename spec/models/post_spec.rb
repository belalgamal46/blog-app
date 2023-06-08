require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it 'belongs to an author' do
      user = User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                         bio: 'Teacher from Mexico.')
      post = Post.create(title: 'Test Post', text: 'Lorem ipsum', comments_counter: 0, likes_counter: 0, author: user)

      expect(post.author).to eq(user)
    end

    it 'has many comments' do
      user = User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                         bio: 'Teacher from Mexico.')
      user2 = User.create(name: 'Belal', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                          bio: 'Teacher from Mexico.')
      post = Post.create(title: 'Test Post', text: 'Lorem ipsum', comments_counter: 0, likes_counter: 0, author: user)
      comment1 = Comment.create(posts: post, text: 'Comment 1', author: user)
      comment2 = Comment.create(posts: post, text: 'Comment 2', author: user2)

      expect(post.comments).to include(comment1, comment2)
    end

    it 'has many likes' do
      user = User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                         bio: 'Teacher from Mexico.')
      user2 = User.create(name: 'Belal', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                          bio: 'Teacher from Mexico.')
      post = Post.create(title: 'Test Post', text: 'Lorem ipsum', comments_counter: 0, likes_counter: 0, author: user)
      like1 = Like.create(posts: post, author: user)
      like2 = Like.create(posts: post, author: user2)

      expect(post.likes).to include(like1, like2)
    end
  end

  describe 'validations' do
    it 'requires a title' do
      user = User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                         bio: 'Teacher from Mexico.')
      post = Post.create(title: '', text: 'Lorem ipsum', comments_counter: 0, likes_counter: 0, author: user)
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it 'limits the title length to 250 characters' do
      user = User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                         bio: 'Teacher from Mexico.')
      post = Post.create(title: 'a' * 251, text: 'Lorem ipsum', comments_counter: 0, likes_counter: 0, author: user)
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include('is too long (maximum is 250 characters)')
    end

    it 'requires comments_counter to be an integer greater than or equal to 0' do
      user = User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                         bio: 'Teacher from Mexico.')
      post = Post.create(title: 'Test Post', text: 'Lorem ipsum', comments_counter: -1, likes_counter: 0, author: user)
      expect(post).not_to be_valid
      expect(post.errors[:comments_counter]).to include('must be greater than or equal to 0')
    end

    it 'requires likes_counter to be an integer greater than or equal to 0' do
      user = User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                         bio: 'Teacher from Mexico.')
      post = Post.create(title: 'Test Post', text: 'Lorem ipsum', comments_counter: 0, likes_counter: -1, author: user)
      expect(post).not_to be_valid
      expect(post.errors[:likes_counter]).to include('must be greater than or equal to 0')
    end
  end

  describe '#five_recent_comments' do
    user = User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                       bio: 'Teacher from Mexico.')
    user2 = User.create(name: 'Belal', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                        bio: 'Teacher from Mexico.')
    user3 = User.create(name: 'Abdallah', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                        bio: 'Teacher from Mexico.')
    post = Post.create(title: 'Test Post', text: 'Lorem ipsum', comments_counter: 0, likes_counter: 0, author: user)
    comment1 = Comment.create(posts: post, text: 'Comment 1', created_at: 1.day.ago, author: user2)
    comment2 = Comment.create(posts: post, text: 'Comment 2', created_at: 2.days.ago, author: user3)
    comment3 = Comment.create(posts: post, text: 'Comment 3', created_at: 3.days.ago, author: user2)
    comment4 = Comment.create(posts: post, text: 'Comment 4', created_at: 4.days.ago, author: user3)
    comment5 = Comment.create(posts: post, text: 'Comment 5', created_at: 5.days.ago, author: user2)
    comment6 = Comment.create(posts: post, text: 'Comment 6', created_at: 6.days.ago, author: user3)

    it 'returns the five most recent comments' do
      expect(post.five_recent_comments).to eq([comment1, comment2, comment3, comment4, comment5])
    end

    it 'does not include comments older than five days' do
      expect(post.five_recent_comments).not_to include(comment6)
    end
  end

  describe 'callbacks' do
    user = User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                       bio: 'Teacher from Mexico.')
    Post.create(title: 'Test Post', text: 'Lorem ipsum', comments_counter: 0, likes_counter: 0, author: user)

    it 'updates the posts_counter on the author after saving' do
      expect do
        Post.create(title: 'Test Post 2', text: 'Lorem ipskkkum', comments_counter: 0, likes_counter: 0, author: user)
      end.to change { user.reload.posts_counter }.from(1).to(2)
    end
  end
end
