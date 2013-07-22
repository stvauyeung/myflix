require 'spec_helper'

feature "Signing in" do
	background { Fabricate(:user, email: "bob@yahoo.com")}

	scenario "signing in with correct credentials" do
		visit "/login"
		fill_in "Email", with: "bob@yahoo.com"
		fill_in "Password", with: "password"
		click_button "Login"
		expect(page).to have_content "Welcome back"
	end

	scenario "signing in with incorrect credentials" do
		visit "/login"
		fill_in "Email", with: "bob@yahoo.com"
		fill_in "Password", with: "not-password"
		click_button "Login"
		expect(page).to have_content "Sorry, email or password was incorrect"
	end
end