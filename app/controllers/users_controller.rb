class UsersController < ApplicationController
  before_filter :require_user, only: [:show]
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    result = Registration.new(@user).sign_up(params[:stripeToken], params[:invitation_token])
    if result.successful?
      session[:user_id] = @user.id
      flash[:success] = "Welcome to MyFlix #{@user.name}!"
      redirect_to home_path  
    else
      flash[:error] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @queuings = @user.queuings
    @reviews = @user.reviews
  end

  def new_with_invitation_token
    invitation = Invitation.find_by_token(params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_link_path
    end
  end
end