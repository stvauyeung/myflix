require 'spec_helper'

feature "Admin sees payments" do
	background do
		alice = Fabricate(:user, name: "Alice", email: "alice@aol.com")
		Fabricate(:payment, amount: 999, user: alice)
	end
	scenario "admin can see payments" do
		sign_in_user(Fabricate(:admin))
		visit admin_payments_path
		page.should have_content("$9.99")
		page.should have_content("Alice")
		page.should have_content("alice@aol.com")
	end
	scenario "user cannot see payments" do
		sign_in_user
		visit admin_payments_path
		page.should_not have_content("$9.99")
		page.should_not have_content("Alice")
		page.should have_content("You do not have permissions for that page.")
	end
end