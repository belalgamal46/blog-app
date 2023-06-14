require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'GET #index' do
    let(:user) do
      User.create(name: 'Tom', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                  bio: 'Teacher from Mexico.')
    end
    let(:post1) { Post.create(title: 'Post 1', text: 'this is Post 1', author: user) }
    let(:post2) { Post.create(title: 'Post 2', text: 'this is Post 2', author: user) }

    before do
      get :index, params: { user_id: user.id }
    end

    it 'assigns @posts' do
      expect(assigns(:posts)).to eq([post1, post2])
    end

    it 'assigns @user' do
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let(:user) do
      User.create(name: 'Holland', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                  bio: 'Teacher from Mexico.')
    end
    let(:post) { Post.create(title: 'Post 1', text: 'this is Post 1', author: user) }

    before do
      get :show, params: { user_id: user.id, id: post.id }
    end

    it 'assigns @post' do
      expect(assigns(:post)).to eq(post)
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end
  end
end
