class AdminsController < ApplicationController
	before_filter :require_user
	
	def require_admin
		unless current_user.admin?
			flash[:error] = "You do not have permissions for that page."
			redirect_to home_path
		end
	end
end