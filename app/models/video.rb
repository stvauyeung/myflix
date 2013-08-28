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

  def rating
    reviews.average(:rating).round(1).to_f if reviews.average(:rating)
  end
end