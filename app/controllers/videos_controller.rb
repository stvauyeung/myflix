class VideosController < ApplicationController
  before_filter :require_user

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews[0..-1]
    @review = @video.reviews.new
  end

  def search
    @videos = Video.search_by_title(params[:q])
  end
end