class Invitation < ActiveRecord::Base
	include Tokenable
	validates_presence_of :recipient_name, :recipient_email, :message, :inviter_id
	belongs_to :inviter, class_name: "User"
end