class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :videos, through: :categorizations

  def recent_videos
    videos.limit(6).order("created_at DESC")
  end
end