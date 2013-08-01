require 'spec_helper'

feature "User resets password" do
	background do 
		Fabricate(:user, name: "Molly", email: "molly@molly.com", password: "password")
	end

	scenario "reseting user password" do
		visit '/login'
		click_forgot_password		

		fill_forgot_password_form('molly@molly.com')		
		check_password_reset_email('molly@molly.com')
		click_email_link
				
		fill_new_password_form('new_password')
		login_with_new_password('new_password')		
	end

	def click_forgot_password
		click_link 'Forgot Password?'
		expect(page).to have_content 'We will send you an email with a link that you can use to reset your password.'	
	end

	def fill_forgot_password_form(email)
		fill_in 'email', with: email
		click_button 'Reset Password'
		page.should have_content 'We have send an email with instruction to reset your password.'
	end

	def check_password_reset_email(email)
		open_email(email)
		current_email.should have_content "Please click the link below to reset your password"
	end

	def click_email_link
		current_email.click_link 'Reset your Myflix Password'
		page.should have_content 'New Password'	
	end

	def fill_new_password_form(new_password)
		fill_in 'password', with: new_password
		click_button 'Reset Password'
		page.should have_content 'Your password has been reset'	
	end

	def login_with_new_password(new_password)
		fill_in 'email', with: 'molly@molly.com'
		fill_in 'password', with: new_password
		click_button 'Login'
		page.should have_content 'Welcome back, Molly'
	end
end