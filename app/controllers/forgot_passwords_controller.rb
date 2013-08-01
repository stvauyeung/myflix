class ForgotPasswordsController < ApplicationController
	def create
		@user = User.where(email: params[:email]).first
		if @user
			AppMailer.password_reset_email(@user).deliver
			redirect_to forgot_password_confirmation_path
		else
			flash[:error] = params[:email].blank? ? "Email cannot be blank." : "Sorry, that email does not exist in our system."
			redirect_to forgot_password_path
		end
	end
end