class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :posts, class_name: 'Post'

  after_save :update_comments_counter
  after_destroy :update_comments_counter
  validates :text, presence: true

def update_comments_counter
  if destroyed?
    posts.decrement!(:comments_counter, 1)
  else
    posts.increment!(:comments_counter, 1)
  end
end
end

