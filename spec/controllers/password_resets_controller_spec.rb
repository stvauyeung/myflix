require 'spec_helper'

describe PasswordResetsController do
	describe "GET show" do
		it "renders show template if the token is valid" do
			alice = Fabricate(:user)
			get :show, id: alice.token
			expect(response).to render_template :show
		end

		it "sets @token" do
			alice = Fabricate(:user)
			get :show, id: alice.token
			expect(assigns(:token)).to eq(alice.token)
		end

		it "redirects to the expired token page if token is not valid" do
			get :show, id: '1234'
			expect(response).to redirect_to expired_link_path
		end
	end

	describe "POST create" do
		context "with valid token" do
			it "redirects to the user sign in page" do
				alice = Fabricate(:user, password: 'old_password')
				post :create, token: alice.token, password: 'new_password'
				expect(response).to redirect_to '/login'
			end
			it "updates the user's password" do
				alice = Fabricate(:user, password: 'old_password')
				post :create, token: alice.token, password: 'new_password'
				expect(alice.reload.authenticate('new_password')).to be_true
			end
			it "sets the flash success message" do
				alice = Fabricate(:user, password: 'old_password')
				post :create, token: alice.token, password: 'new_password'
				expect(flash[:success]).to eq("Your password has been reset")
			end
			it "regenerates the user token" do
				alice = Fabricate(:user, password: 'old_password')
				alice.update_column(:token, '1234')
				post :create, token: '1234', password: 'new_password'
				expect(alice.reload.token).not_to eq('1234')
			end
		end
		context "with invalid token" do
			it "redirects to the expired path" do
				post :create, token: '1234', password: 'new_password'
				expect(response).to redirect_to expired_link_path
			end
		end
	end
end