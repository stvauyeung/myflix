class QueuingsController < ApplicationController
  before_filter :require_user

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to queuings_path
  end

  def index
    @user = current_user
    @queuings = current_user.queuings
  end

  def destroy
    queuing = Queuing.find(params[:id])
    queuing.destroy if queuing.user == current_user
    current_user.normalize_queuing_positions
    redirect_to queuings_path
  end

  def update_multiple
    begin
      current_user.update_queuings(params[:queuing_updates])
      current_user.normalize_queuing_positions
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Please input valid position numbers only"
    end
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