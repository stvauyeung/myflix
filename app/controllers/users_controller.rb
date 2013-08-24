class UsersController < ApplicationController
  before_filter :require_user, only: [:show]
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999,
        card: params[:stripeToken],
        description: "#{@user.email} registration fee"
        )
      if charge.successful?
        @user.save
        handle_invitation
        AppMailer.welcome_email(@user).deliver
        session[:user_id] = @user.id
        flash[:success] = "Welcome to MyFlix #{@user.name}!"
        redirect_to home_path  
      else
        flash[:error] = charge.error_message
        render :new
      end
    else
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

  private

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by_token(params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end 
  end
end