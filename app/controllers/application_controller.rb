class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?, :admin?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def admin?
    current_user.admin?
  end

  def require_user
    unless logged_in?
      flash[:error] = "You must be logged in to do that!"
      redirect_to login_path
    end
  end
end
