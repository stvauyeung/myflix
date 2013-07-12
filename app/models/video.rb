class Video < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :reviews

  validates_presence_of :title, :description
  validates_uniqueness_of :title

  def self.search_by_title(search)
    return [] if search.blank?
    where("title LIKE ?", "%#{search}%").order('created_at DESC')
  end

  def average_rating
    if reviews.count > 1
      total_ratings = 0
      reviews.each do |r|
          total_ratings += r.rating unless r.rating.nil?
      end
      "#{(total_ratings/reviews.count)}/5"
    else
      "Not Rated"
    end
  end
end