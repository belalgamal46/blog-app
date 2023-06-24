Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#index"
  resources :users, only: [:index, :show] do
    resources :posts, only: [:index, :show, :new, :create, :destroy] do
      resources :comments, only: [:create, :new, :destroy]
      resources :likes, only: [:create, :destroy]
    end
  end

  namespace :api do
    get "/users/:user_id/posts", to: "posts#index", as: "user_posts"
    get "/users/:user_id/posts/:post_id/comments", to: "comments#index", as: "user_post_comments"
    post "/users/:user_id/posts/:post_id/comments", to: "comments#create", as: "create_user_post_comments"
  end

end
