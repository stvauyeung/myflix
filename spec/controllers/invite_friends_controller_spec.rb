require 'spec_helper'

describe InviteFriendsController do
	context "with signed in user" do
		let(:joe) { Fabricate(:user) }
		before { set_current_user(joe) }

		describe "GET new" do
			it "sets user email as @email" do
				get :new
				expect(assigns(:email)).to eq(joe.email)
			end
		end

		describe "POST create" do
			it "sends email to friend email"
			it "sets current user email as from email"
			it "redirects to home path"
			it "displays flash message"
		end
	end
end