class User < ActiveRecord::Base
  validates_presence_of :name, :email
  validates :email, uniqueness: true, format: { :with => /@/, :on => :create}

  has_secure_password
  validates :password, presence: true, on: :create

  has_many :reviews
  has_many :queuings, order: :position

  has_many :followings
  has_many :followers, through: :followings

  def update_queuings(queuing_updates)
    ActiveRecord::Base.transaction do
      queuing_updates.each do |hash|
        queuing = Queuing.find(hash["id"])
        queuing.update_attributes!(position: hash["position"], rating: hash["rating"]) if queuing.user == self
      end
    end 
  end

  def normalize_queuing_positions
    queuings.each_with_index do |queuing, index|
      queuing.update_attributes(position: index + 1)
    end 
  end

  def in_queuings?(video)
    queuings.map(&:video).include?(video)
  end

  def is_following
    Following.where(follower_id: self.id)
  end
end