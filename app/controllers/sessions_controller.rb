class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by_name(params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, :notice => "Welcome back, #{user.name}"
    else
      flash.now[:error] = "Sorry, name or password was incorrect."
      render 'sessions/new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/', :notice => "You've been successfully logged out."
  end
end