require 'spec_helper'

describe "Deactivate user on failed charge" do
	let(:event_data) do
		{
		  "id" => "evt_2Vmd45mHekGQV7",
		  "created" => 1378319509,
		  "livemode" => false,
		  "type" => "charge.failed",
		  "data" => {
		    "object" => {
		      "id" => "ch_2VmdrkPen1QLqY",
		      "object" => "charge",
		      "created" => 1378319509,
		      "livemode" => false,
		      "paid" => false,
		      "amount" => 999,
		      "currency" => "usd",
		      "refunded" => false,
		      "card" => {
		        "id" => "card_2VmbGOez07uKmG",
		        "object" => "card",
		        "last4" => "0341",
		        "type" => "Visa",
		        "exp_month" => 9,
		        "exp_year" => 2017,
		        "fingerprint" => "7jBNtR5oBZQjZDig",
		        "customer" => "cus_2V6TP5agP8zBB1",
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
		      "captured" => false,
		      "refunds" => [],
		      "balance_transaction" => nil,
		      "failure_message" => "Your card was declined.",
		      "failure_code" => "card_declined",
		      "amount_refunded" => 0,
		      "customer" => "cus_2V6TP5agP8zBB1",
		      "invoice" => nil,
		      "description" => "failed payment",
		      "dispute" => nil
		    }
		  },
		  "object" => "event",
		  "pending_webhooks" => 1,
		  "request" => "iar_2Vmd0e6bCAfHBb"
		}
	end

	it "deactivates a user with stripe webhook charge failed", :vcr do
		alice = Fabricate(:user, customer_token: "cus_2V6TP5agP8zBB1")
		post "/stripe_events", event_data
		expect(alice.reload).not_to be_active
	end
end