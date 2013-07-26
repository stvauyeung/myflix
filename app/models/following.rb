class Following < ActiveRecord::Base
	belongs_to :user # consider calling followed
	belongs_to :follower, :class_name => 'User'

	delegate :name, to: :user, prefix: :user
	validates_uniqueness_of :user_id, scope: :follower_id
	
	def user_queue
		user.queuings.count
	end

	def user_followers
		user.followings.count
	end
end