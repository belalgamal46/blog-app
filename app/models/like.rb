class Like < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :posts, class_name: 'Post'

  after_save :update_likes_counter
  after_destroy :update_likes_counter

  def update_likes_counter
    if destroyed?
      posts.decrement!(:likes_counter, 1)
    else
      posts.increment!(:likes_counter, 1)
    end
  end
end
