require 'spec_helper'

feature 'New user registers with payment', { js: true, vcr: true } do
	before { visit register_path }

	scenario 'Valid user and valid credit card' do
		fill_in_user('bob@bob.com')
		fill_in_credit_card('4242424242424242')
		click_button 'Sign Up'
		page.should have_content 'Welcome to MyFlix Bob!'
	end
	scenario 'Valid user and invalid credit card' do
		fill_in_user('bob@bob.com')
		fill_in_credit_card('123123')
		click_button 'Sign Up'
		page.should have_content "This card number looks invalid"
	end
	scenario 'Valid user and declined card' do
		fill_in_user('bob@bob.com')
		fill_in_credit_card('4000000000000002')
		click_button 'Sign Up'
		page.should have_content "Your card was declined."
	end
	scenario 'Invalid user and valid credit card' do
		fill_in_user(nil)
		fill_in_credit_card('4242424242424242')
		click_button 'Sign Up'
		page.should have_content "can't be blank, is invalid"
	end
	scenario 'Invalid user and invalid credit card' do
		fill_in_user(nil)
		fill_in_credit_card('40012')
		click_button 'Sign Up'
		page.should have_content "This card number looks invalid"
	end
	scenario 'Invalid user and declined card' do
		fill_in_user(nil)
		fill_in_credit_card('4000000000000002')
		click_button 'Sign Up'
		page.should have_content "can't be blank, is invalid"
	end

	def fill_in_user(email)
		fill_in 'user_name', with: 'Bob'
		fill_in 'user_email', with: email
		fill_in 'user_password', with: 'password'
		fill_in 'user_password_confirmation', with: 'password'
	end

	def fill_in_credit_card(number)
		fill_in 'credit-card-number', with: number
		fill_in 'security-code', with: '345'
		select '7 - July', from: 'date_month'
		select '2016', from: 'date_year'
	end
end