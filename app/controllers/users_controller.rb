class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to home_path
    else
      flash.now[:error] = "#{@user.errors.full_messages}"
      render :action => :new
    end
  end
end