require 'spec_helper'

feature "Signing in" do
	scenario "signing in with correct credentials" do
		sign_in_user
		expect(page).to have_content "Welcome back"
	end

	scenario "signing in with incorrect credentials" do
		Fabricate(:user, email: "bob@yahoo.com")
		visit "/login"
		fill_in "Email", with: "bob@yahoo.com"
		fill_in "Password", with: "not-password"
		click_button "Login"
		expect(page).to have_content "Sorry, email or password was incorrect"
	end

	scenario "with a deactivated user" do
		alice = Fabricate(:user, active: false)
		sign_in_user(alice)
		expect(page).not_to have_content alice.name
		expect(page).to have_content("Your account has been suspended")
	end
end