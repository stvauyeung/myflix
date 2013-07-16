class QueuingsController < ApplicationController
  before_filter :require_user

  def create
    video = Video.find(params[:video_id])
    queuing = video.queuings.create(user_id: current_user.id, position: current_user.queuings.count + 1)
    redirect_to video_path(video)
  end

  def index
    @user = current_user
    @queuings = @user.queuings
  end
end