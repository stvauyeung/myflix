class ReviewsController < ApplicationController
  before_filter :require_user
  
  def new
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new
  end

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(params[:review])
    @review.user = current_user
    if @review.save
      redirect_to video_path(@video)
    else
      redirect_to video_path(@video)
    end
  end
end