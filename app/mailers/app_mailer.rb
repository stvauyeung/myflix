class AppMailer < ActionMailer::Base
	default from: 'myflix88@gmail.com'

	def welcome_email(new_user)
		@user = new_user
		@url = home_path
		mail(to: "#{@user.email}", subject: "Holy moly, you joined Myflix. What's next?")
	end
end