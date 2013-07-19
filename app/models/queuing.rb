class Queuing < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true
  validates :video_id, presence: true
  validates_numericality_of :position, only_integer: true

  delegate :title, to: :video, prefix: :video

  def user_rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end

  def category_name
    video.categories.first.name
  end

  def category
    video.categories.first
  end
end