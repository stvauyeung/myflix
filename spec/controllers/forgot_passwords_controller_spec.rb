require 'spec_helper'

describe ForgotPasswordsController do
	describe "POST create" do
		context "with blank input" do
			it "redirects to the forgot password page" do
				post :create, email: ""
				expect(response).to redirect_to forgot_password_path
			end
			it "shows and error message" do
				post :create, email: ""
				expect(flash[:error]).to eq("Email cannot be blank.")
			end
		end
		context "with existing email" do
			let(:joe) { Fabricate(:user) }
			it "should redirect to forgot password confirmation page" do
				post :create, email: joe.email
				expect(response).to redirect_to forgot_password_confirmation_path
			end
			it "should send out email to email address" do
				post :create, email: joe.email
				expect(ActionMailer::Base.deliveries.last.to).to eq([joe.email])
			end
		end
		context	"with non-existing email" do
			it "redirects to the forgot password page" do
				post :create, email: "joe@gmail.com"
				expect(response).to redirect_to forgot_password_path
			end
			it "shows an error message" do
				post :create, email: "joe@gmail.com"
				expect(flash[:error]).to eq("Sorry, that email does not exist in our system.")
			end
		end
		# let(:joe) { Fabricate(:user) }
		# it "redirects to home page" do
		# 	post :create, email: joe.email
		# 	expect(response).to redirect_to root_path
		# end
		# it "sets a password reset token for user" do
		# 	post :create, email: joe.email
		# 	expect(joe.reset_token).not_to be_nil
		# end
		# it "displays flash message"

		# context "email sending" do
		# 	it "sends out an email"
		# 	it "sends to the passed email"
		# end
	end
end