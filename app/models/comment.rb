class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :posts, class_name: 'Post'

  def update_comments_counter
    posts.increment!(:comments_counter, 1)
  end
end
