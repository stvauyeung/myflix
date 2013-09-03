class AdminsController < ApplicationController
	before_filter :require_admin

	private

	def require_admin
		if !current_user.admin
			flash[:error] = "You do not have permissions for that page."
			redirect_to home_path
		end
	end
end