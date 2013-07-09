class Video < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, through: :categorizations

  validates_presence_of :title, :description
  validates_uniqueness_of :title

  def self.search_by_title(search)
    return [] if search.blank?
    where("title LIKE ?", "%#{search}%").order('created_at DESC')
  end
end