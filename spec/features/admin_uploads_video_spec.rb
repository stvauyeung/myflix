require 'spec_helper'

feature "Admin creates a video" do
	let(:admin) { Fabricate(:user, admin: true) }
	scenario "Admin adds video" do
		sign_in_user(admin)
	end
end