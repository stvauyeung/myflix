class Video < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, through: :categorizations

  validates_presence_of :title, :description
  validates_uniqueness_of :title

  def self.search_by_title(search)
    query = "%" + search + "%"
    find(:all, :conditions => ['title LIKE ?', query])  
  end
end