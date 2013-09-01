class Registration
	attr_reader :error_message

	def initialize(user)
		@user = user
	end

	def sign_up(stripe_token, invitation_token)
    if @user.valid?
  		customer = StripeWrapper::Customer.create(
          card: stripe_token,
          plan: "myflix",
          user: @user
          )
      if customer.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.welcome_email(@user).deliver
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Invalid user information, please see errors below."
      self
    end
	end

  def successful?
    @status == :success
  end

  private

	def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by_token(invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end 
  end
end