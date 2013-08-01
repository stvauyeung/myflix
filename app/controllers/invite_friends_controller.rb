class InviteFriendsController < ApplicationController
	def new
		@email = current_user.email
	end

	def create
	end
end