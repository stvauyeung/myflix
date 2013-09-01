require 'spec_helper'

describe Registration do
	describe "#registration" do
		context "valid personal info and valid card" do
			before do
        customer = double(:customer, successful?: true)
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end
      after do
      	ActionMailer::Base.deliveries.clear
      end

			it "saves new user in db" do
        Registration.new(Fabricate.build(:user)).sign_up("stripetoken", nil)
        expect(User.count).to eq(1)
      end
      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'j@joe.com')
        Registration.new(Fabricate.build(:user, email: "j@joe.com", name: "Joe", password: "password")).sign_up("stripetoken", invitation.token)
        joe = User.find_by_email("j@joe.com")
        expect(joe.follows?(alice)).to be_true
      end
      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'j@joe.com')
        Registration.new(Fabricate.build(:user, email: "j@joe.com", name: "Joe", password: "password")).sign_up("stripetoken", invitation.token)
        joe = User.find_by_email("j@joe.com")
        expect(alice.follows?(joe)).to be_true
      end
      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'j@joe.com')
        Registration.new(Fabricate.build(:user, email: "j@joe.com", name: "Joe", password: "password")).sign_up("stripetoken", invitation.token)
        joe = User.find_by_email("j@joe.com")
        expect(Invitation.first.token).to be_nil
      end
      it "sends out an email" do
        Registration.new(Fabricate.build(:user)).sign_up("stripetoken", nil)
        ActionMailer::Base.deliveries.should_not be_empty
      end
      it "sends to new user" do
        Registration.new(Fabricate.build(:user, email: "j@joe.com")).sign_up("stripetoken", nil)
        message = ActionMailer::Base.deliveries.last
        message.to.should eq(["j@joe.com"])
      end
      it "has the right content" do
        Registration.new(Fabricate.build(:user, name: "Joe")).sign_up("stripetoken", nil)
        message = ActionMailer::Base.deliveries.last
        message.html_part.body.should include "Welcome to Myflix, Joe"
      end
		end

		context "with valid personal info and declined card" do
      before do
        customer = double(:customer, successful?: false, error_message: 'message')
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end
      it "does not create a new user" do
        Registration.new(Fabricate.build(:user)).sign_up("stripetoken", nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      it "does not save new user in db" do
        Registration.new(User.new(email: "joe@joe.com", password: "password")).sign_up("stripetoken", nil)
        expect(User.count).to eq(0)
      end
      it "does not charge the credit card" do
        StripeWrapper::Customer.should_not_receive(:create)
        Registration.new(User.new(email: "joe@joe.com", password: "password")).sign_up("stripetoken", nil)
      end
      it "does not set out email" do
      	Registration.new(User.new(email: "joe@joe.com", password: "password")).sign_up("stripetoken", nil)
      	expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
	end
end