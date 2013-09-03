class Admin::VideosController < AdminsController
	before_filter :require_user

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
end