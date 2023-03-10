require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /index' do
    let(:user) { User.create!(name: 'Alice', posts_counter: 0) }
    it 'displays a list of all posts' do
      get '/users/1/posts'
      expect(response).to be_successful
      expect(response.body).to include('Posts List')
    end
    it 'renders the index template' do
      get user_posts_path(user)
      expect(response).to render_template('index')
    end
  end

  describe 'GET /show' do
    let(:user) { User.create!(name: 'Alice', posts_counter: 0) }
    let(:post) do
      user.posts.create!(title: 'Post 1', text: 'Body 1', comments_counter: 0, likes_counter: 0)
    end
    it "displays the post's title and body" do
      get '/users/1/posts/1'
      expect(response).to be_successful
      expect(response.body).to include('Show Post Details')
    end
    it 'renders the show template' do
      get user_post_path(user, post)
      expect(response).to render_template('show')
    end
  end
end
