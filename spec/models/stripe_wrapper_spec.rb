require 'spec_helper'

describe StripeWrapper::Charge do
	before { StripeWrapper.set_api_key }
	let(:token) do
		Stripe::Token.create(
			:card => { 
				:number => card_number,
				:exp_month => 8,
				:exp_year => 2016,
				:cvc => "314"
			}
		).id
	end

	context "with valid card", :vcr do
		let(:card_number) { '4242424242424242' }
		it "charges the card successfully" do
			response = StripeWrapper::Charge.create(amount: 300, card: token, description: 'test charge')
			response.should_not be_failed
		end
	end
	
	context "with invalid card" do
		let(:card_number) { '4000000000000002' }
		let(:response) { StripeWrapper::Charge.create(amount: 300, card: token, description: 'test charge') }
		it "does not charge the card successfully", :vcr do
			response.should be_failed
		end
		it "contains an error message", :vcr do
			response.error_message.should be_present
		end
	end
end