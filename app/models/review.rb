class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :content
  validates_inclusion_of :rating, :in => 1..5
  delegate :title, to: :video, prefix: :video

end