class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :posts, class_name: 'Post'

  after_save :update_comments_counter
  validates :text, presence: true

  def update_comments_counter
    posts.increment!(:comments_counter, 1)
  end
end
