class InvitationsController < ApplicationController
	before_filter :require_user

	def new
		@invitation = Invitation.new
	end

	def create
		@invitation = Invitation.create(params[:invitation].merge!(inviter_id: current_user.id))
		if @invitation.save
			AppMailer.invite_friend_email(@invitation).deliver
			flash[:success] = "Thanks for sharing Myflix with #{@invitation.recipient_name}!"
			redirect_to invitations_path
		else
			flash[:error] = "Please fix the errors below."
			render :new
		end
	end
end