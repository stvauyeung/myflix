class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to home_path
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, :notice => "Welcome back, #{user.name}"
    else
      flash.now[:error] = "Sorry, email or password was incorrect."
      render 'sessions/new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/', :notice => "You've been successfully logged out."
  end
end