class Admin::VideosController < ApplicationController
	before_filter :require_user
	before_filter :require_admin

	def new
		@video = Video.new
	end

	def create
		@video = Video.new(params[:video].except(:categories))
		if @video.save
			@video.categories << Category.find(params[:video][:categories])
			flash[:success] = "You successfully added #{@video.title}."
			redirect_to new_admin_video_path
		else
			flash[:error] = "Please fix the following errors."
			render :new
		end
	end

	private

	def require_admin
		if !current_user.admin
			flash[:error] = "You do not have permissions for that page."
			redirect_to home_path
		end
	end
end