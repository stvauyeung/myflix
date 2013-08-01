require 'spec_helper'

feature "User resets password" do
	background do 
		Fabricate(:user, email: "molly@molly.com", password: "password")
	end

	scenario "reseting user password" do
		visit '/login'
		
		click_link 'Forgot Password?'
		expect(page).to have_content "We will send you an email with a link that you can use to reset your password."

		fill_in 'email', with: 'molly@molly.com'
		click_button 'Reset Password'
		expect(page).to have_content "We have send an email with instruction to reset your password."
	end
end