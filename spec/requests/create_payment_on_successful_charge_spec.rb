require 'spec_helper'

describe "Create payment on successful charge" do
	let(:event_data) do
		{
		  "id" => "evt_2V4NLPQNlgGDow",
		  "created" => 1378154890,
		  "livemode" => false,
		  "type" => "charge.succeeded",
		  "data" => {
		    "object" => {
		      "id" => "ch_2V4N5gihqxN5aQ",
		      "object" => "charge",
		      "created" => 1378154889,
		      "livemode" => false,
		      "paid" => true,
		      "amount" => 999,
		      "currency" => "usd",
		      "refunded" => false,
		      "card" => {
		        "id" => "card_2V4Ns2J3G2FBZ7",
		        "object" => "card",
		        "last4" => "4242",
		        "type" => "Visa",
		        "exp_month" => 9,
		        "exp_year" => 2015,
		        "fingerprint" => "I3rI5FeqnwY9lE0k",
		        "customer" => "cus_2V4NFeexwRMknd",
		        "country" => "US",
		        "name" => nil,
		        "address_line1" => nil,
		        "address_line2" => nil,
		        "address_city" => nil,
		        "address_state" => nil,
		        "address_zip" => nil,
		        "address_country" => nil,
		        "cvc_check" => "pass",
		        "address_line1_check" => nil,
		        "address_zip_check" => nil
		      },
		      "captured" => true,
		      "refunds" => [],
		      "balance_transaction" => "txn_2V4NnoKhyDQPRp",
		      "failure_message" => nil,
		      "failure_code" => nil,
		      "amount_refunded" => 0,
		      "customer" => "cus_2V4NFeexwRMknd",
		      "invoice" => "in_2V4NmpjEPJ1Syh",
		      "description" => nil,
		      "dispute" => nil
		    }
		  },
		  "object" => "event",
		  "pending_webhooks" => 1,
		  "request" => "iar_2V4NQDEW0j4aY5"
		}
	end
	it "creates a payment with a webhook from stripe for charge succeeded", :vcr do
		post "/stripe_events", event_data
		expect(Payment.count).to eq(1)
	end
	it "creates the payment associated with user", :vcr do
		alice = Fabricate(:user, customer_token: "cus_2V4NFeexwRMknd")
		post "/stripe_events", event_data
		expect(Payment.first.user).to eq(alice)
	end
	it "creates the payment with the amount", :vcr do
		alice = Fabricate(:user, customer_token: "cus_2V4NFeexwRMknd")
		post "/stripe_events", event_data
		expect(Payment.first.amount).to eq(999)
	end
	it "creates the payment with reference id", :vcr do
		alice = Fabricate(:user, customer_token: "cus_2V4NFeexwRMknd")
		post "/stripe_events", event_data
		expect(Payment.first.reference_id).to eq("ch_2V4N5gihqxN5aQ")
	end
end