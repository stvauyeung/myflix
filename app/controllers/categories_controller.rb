class CategoriesController < ApplicationController
  before_filter :require_user
  
  def show
    @category = Category.find(params[:id])
    @videos = @category.videos
  end
end