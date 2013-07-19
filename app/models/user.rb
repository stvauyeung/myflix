class User < ActiveRecord::Base
  validates_presence_of :name, :email
  validates :email, uniqueness: true, format: { :with => /@/, :on => :create}

  has_secure_password
  validates :password, presence: true, on: :create

  has_many :reviews
  has_many :queuings, order: :position
end