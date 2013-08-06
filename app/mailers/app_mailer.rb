class AppMailer < ActionMailer::Base
	default from: 'myflix88@gmail.com'

	def welcome_email(new_user)
		@user = new_user
		@url = home_path
		mail(to: "#{@user.email}", subject: "Holy moly, you joined Myflix. What's next?")
	end

	def password_reset_email(existing_user)
		@user = existing_user
		mail(to: "#{@user.email}", subject: "MyFlix password reset instructions")
	end

	def invite_friend_email(invitation)
		@invitation = invitation
		mail(from: @invitation.inviter.email,
				 to: @invitation.recipient_email,
				 subject: "#{@invitation.recipient_name}, you've been invite to Myflix!",
				 )
	end
end