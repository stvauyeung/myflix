class FollowingsController < ApplicationController
	before_filter :require_user

	def index
		@followings = current_user.is_following
	end

	def destroy
		following = Following.find(params[:id])
		following.destroy if following.follower == current_user
		flash[:success] = "You are no longer following #{following.user.name}"
		redirect_to followings_path
	end

	def create
		create_following(params[:user_id])
		followed_user = User.find(params[:user_id])
		flash[:success] = "You started following #{followed_user.name}"
		redirect_to followings_path
	end

	private

	def create_following(user_id)
		Following.create(user_id: user_id, follower_id: current_user.id) unless current_user.id == user_id.to_i
	end
end