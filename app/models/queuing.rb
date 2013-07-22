class Queuing < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true
  validates :video_id, presence: true
  validates_numericality_of :position, only_integer: true

  delegate :title, to: :video, prefix: :video

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review      
      review.update_column(:rating, new_rating)
    else
      new_review = Review.new(user_id: user.id, video_id: video.id, rating: new_rating)
      new_review.save(validate: false)
    end
  end

  def category_name
    video.categories.first.name
  end

  def category
    video.categories.first
  end

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end