class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        redirect_to home_path, :notice => "Welcome back, #{user.name}"
      else
        flash[:error] = "Your account has been suspended.  Please contact customer service."
        redirect_to login_path
      end
    else
      flash.now[:error] = "Sorry, email or password was incorrect."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "You've been successfully logged out."
  end
end