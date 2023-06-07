class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :comments, foreign_key: 'posts_id'
  has_many :likes, foreign_key: 'posts_id'

  def update_posts_counter
    author.increment!(:posts_counter, 1)
  end

  def five_recent_comments
    comments.order(created_at: :desc).limit(5)
  end
end
