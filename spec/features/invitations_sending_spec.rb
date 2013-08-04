require 'spec_helper'

feature "User invites a friend" do
	let(:jason) { Fabricate(:user, name: 'Jason') }
	scenario "User sends an invitation" do
		sign_in_user(jason)

		click_invite_friends
		submit_invite_form('Paul', 'paul@example.com')
		click_link 'Sign Out'

		open_invite_email('Paul', 'paul@example.com')
		register_user('Paul')

		expect_following('Jason')

		click_link 'Sign Out'
		sign_in_user(jason)
		
		expect_following('Paul')

		clear_email
	end

	def click_invite_friends
		click_link 'Invite Friends'
		page.should have_content 'Invite a friend to join MyFlix!'	
	end

	def submit_invite_form(name, email)
		fill_in "Friend's Name", with: name
		fill_in "Friend's Email Address", with: email
		fill_in "Invitation Message", with: 'Join this!'
		click_button 'Send Invitation'
		page.should have_content 'Thanks for sharing Myflix with'
	end

	def open_invite_email(recipient_name, recipient_email)
		open_email(recipient_email)
		current_email.should have_content "Hello #{recipient_name}"
		current_email.click_link 'Join MyFlix!'
		page.should have_content 'Register'	
	end

	def register_user(name, password='password')
		fill_in 'Full Name', with: name
		fill_in 'Password', with: password
		fill_in 'Confirm Password', with: password
		click_button 'Register'
		page.should have_content "Welcome, #{name}"	
	end

	def expect_following(user_name)
		click_link 'People'
		page.should have_content user_name	
	end
end