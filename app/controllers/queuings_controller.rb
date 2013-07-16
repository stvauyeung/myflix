class QueuingsController < ApplicationController
  before_filter :require_user

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to video_path(video)
  end

  def index
    @user = current_user
    @queuings = @user.queuings
  end

  def destroy
    queuing = Queuing.find(params[:id])
    queuing.destroy unless queuing.user != current_user
    redirect_to queuings_path
  end

  private

  def queue_video(video)
    video.queuings.create(user_id: current_user.id, position: queuing_position) unless queuings_include?(video)
  end

  def queuing_position
    current_user.queuings.count + 1
  end

  def queuings_include?(video)
    current_user.queuings.map(&:video).include?(video)
  end
end