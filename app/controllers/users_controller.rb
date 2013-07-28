class UsersController < ApplicationController
  before_filter :require_user, only: [:show]
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      AppMailer.welcome_email(@user).deliver
      session[:user_id] = @user.id
      redirect_to home_path
    else
      flash.now[:error] = "#{@user.errors.full_messages}"
      render :action => :new
    end
  end

  def show
    @user = User.find(params[:id])
    @queuings = @user.queuings
    @reviews = @user.reviews
  end
end