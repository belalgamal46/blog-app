require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    let!(:user1) do
      User.create(name: 'John Doe', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                  bio: 'Teacher from Mexico.')
    end
    let!(:user2) do
      User.create(name: 'Jane Smith', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                  bio: 'Teacher from Mexico.')
    end

    before do
      get :index
    end

    it 'assigns @users' do
      expect(assigns(:users)).to eq([user1, user2])
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let!(:user) do
      User.create(name: 'John Doe', posts_counter: 0, photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                  bio: 'Teacher from Mexico.')
    end

    before do
      get :show, params: { id: user.id }
    end

    it 'assigns @user' do
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end
  end
end
