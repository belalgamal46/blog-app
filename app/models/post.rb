class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :comments, foreign_key: 'posts_id', dependent: :destroy
  has_many :likes, foreign_key: 'posts_id', dependent: :destroy

  validates :title, presence: true, length: { minimum: 4, maximum: 250 }
  validates :text, presence: true, length: { minimum: 5, maximum: 1000 }
  validates :comments_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :likes_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def five_recent_comments
    comments.order(created_at: :desc).limit(5)
  end

  after_save :update_posts_counter
  after_destroy :update_posts_counter

  private

  def update_posts_counter
    if destroyed?
      author.decrement!(:posts_counter, 1)
    else
      author.increment!(:posts_counter, 1)
    end
  end
end
