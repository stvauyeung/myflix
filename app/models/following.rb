class Following < ActiveRecord::Base
	belongs_to :user
	belongs_to :follower, :class_name => 'User'

	delegate :name, to: :user, prefix: :user
	
	def user_queue
		user.queuings.count
	end

	def user_followers
		user.followings.count
	end
end