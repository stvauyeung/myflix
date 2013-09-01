require 'spec_helper'

describe StripeWrapper do
	let(:valid_token) do
		Stripe::Token.create(
			:card => { 
				:number => "4242424242424242",
				:exp_month => 8,
				:exp_year => 2016,
				:cvc => "314"
			}
		).id
	end
	let(:invalid_token) do
		Stripe::Token.create(
			:card => { 
				:number => "4000000000000002",
				:exp_month => 8,
				:exp_year => 2016,
				:cvc => "314"
			}
		).id
	end

	describe StripeWrapper::Charge do
		before { StripeWrapper.set_api_key }
		context "with valid card", :vcr do
			it "charges the card successfully" do
				response = StripeWrapper::Charge.create(amount: 300, card: valid_token, description: 'test charge')
				response.should be_successful
			end
		end
		
		context "with invalid card" do
			let(:response) { StripeWrapper::Charge.create(amount: 300, card: invalid_token, description: 'test charge') }
			it "does not charge the card successfully", :vcr do
				response.should_not be_successful
			end
			it "contains an error message", :vcr do
				response.error_message.should be_present
			end
		end
	end

	describe StripeWrapper::Customer do
		describe ".create" do
			before { StripeWrapper.set_api_key }
			let(:alice) { Fabricate(:user) }
			it "creates a customer with valid card", :vcr do
				response = StripeWrapper::Customer.create(user: alice, card: valid_token)
				response.should be_successful
			end
			it "does not create a customer with declined card", :vcr do
				response = StripeWrapper::Customer.create(user: alice, card: invalid_token)
				response.should_not be_successful
			end
			it "returns error message for declined card", :vcr do
				response = StripeWrapper::Customer.create(user: alice, card: invalid_token)
				response.error_message.should eq("Your card was declined.")
			end
		end
	end
end
