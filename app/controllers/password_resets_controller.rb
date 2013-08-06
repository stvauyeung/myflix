class PasswordResetsController < ApplicationController
	def show
		user = User.find_by_token(params[:id])
		if user
			@token = params[:id]
		else
			redirect_to expired_link_path
		end
	end

	def create
		user = User.find_by_token(params[:token])
		if user
			reset_password(user)
			flash[:success] = "Your password has been reset"
			redirect_to login_path
		else
			redirect_to expired_link_path
		end
	end

	def expired_token	
	end

	private

	def reset_password(user)
		user.password = params[:password]
		user.update_column(:token, SecureRandom.urlsafe_base64)
		user.save!
	end
end