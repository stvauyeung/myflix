class Video < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, through: :categorizations

  validates_presence_of :title, :description
  validates_uniqueness_of :title
end