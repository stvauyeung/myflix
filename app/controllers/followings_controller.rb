class FollowingsController < ApplicationController
	before_filter :require_user

	def index
		@followings = current_user.is_following
	end

	def destroy
		following = Following.find(params[:id])
		following.destroy if following.follower == current_user
		redirect_to followings_path
	end

	def create
		create_following(params[:user_id])
		redirect_to followings_path
	end

	private

	def create_following(user_id)
		Following.create(user_id: user_id, follower_id: current_user.id) unless current_user.follows?(User.find(user_id))
	end
end