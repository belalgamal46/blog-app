class Like < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :posts, class_name: 'Post'

  after_save :update_likes_counter

  def update_likes_counter
    posts.increment!(:likes_counter, 1)
  end
end
