class Video < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :reviews, order: "created_at DESC"
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description
  validates_uniqueness_of :title

  has_many :queuings

  def self.search_by_title(search)
    return [] if search.blank?
    where("title LIKE ?", "%#{search}%").order('created_at DESC')
  end

  def average_rating
    if reviews.count > 0
      total_ratings = 0
      reviews.each do |r|
          total_ratings += r.rating unless r.rating.nil?
      end
      total_ratings/reviews.count
    else
      "Not Rated"
    end
  end
end