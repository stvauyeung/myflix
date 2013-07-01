class Video < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, through: :categorizations

  validates :title, presence: true
  validates :description, presence: true
end