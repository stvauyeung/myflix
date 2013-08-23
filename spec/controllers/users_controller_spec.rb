require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns a new user to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    it "creates a new instance of User" do
      StripeWrapper::Charge.stub(:create)
      post :create
      expect(assigns(:user)).to be_a_new(User)
    end

    context "with valid user attributes" do
      before do
        charge = double(:charge, successful?: true)
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it "saves new user in db" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}
        expect(User.count).to eq(1)
      end
      it "redirects to /home" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}
        expect(response).to redirect_to home_path
      end
      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'j@joe.com')
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}, invitation_token: invitation.token
        joe = User.find_by_email("j@joe.com")
        expect(joe.follows?(alice)).to be_true
      end
      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'j@joe.com')
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}, invitation_token: invitation.token
        joe = User.find_by_email("j@joe.com")
        expect(alice.follows?(joe)).to be_true
      end
      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'j@joe.com')
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}, invitation_token: invitation.token
        joe = User.find_by_email("j@joe.com")
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with valid personal info and declined card" do
      before do
        charge = double(:charge, successful?: false, error_message: 'message')
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end
      it "does not create a new user" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}, stripeToken: '12345'
        expect(User.count).to eq(0)
      end
      it "renders the new template" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}, stripeToken: '12345'
        expect(response).to render_template :new
      end
      it "sets flash error message" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}, stripeToken: '12345'
        expect(flash[:error]).to be_present
      end
    end

    context "with invalid personal info" do
      it "does not save new user in db" do
        expect{
          post :create, :user => {name: "Joe", email: "j@joe.com", password:""}
        }.to_not change(User, :count)
      end
      it "renders :new template" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: ""}
        expect(response).to render_template(:new)
      end
      it "does not charge the credit card" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, :user => {name: "Joe", email: "j@joe.com", password: ""}
      end
    end

    context "email sending" do
      before do
        charge = double(:charge, successful?: true)
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it "sends out an email" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}
        ActionMailer::Base.deliveries.should_not be_empty
      end
      it "sends to new user" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}
        message = ActionMailer::Base.deliveries.last
        message.to.should eq(["j@joe.com"])
      end
      it "has the right content" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}
        message = ActionMailer::Base.deliveries.last
        message.html_part.body.should include "Welcome to Myflix, Joe"
      end
    end
  end

  describe "GET show" do
    let(:joe) { Fabricate(:user) }
    before do
      set_current_user
    end
    it "sets @user" do
      get :show, id: joe.id
      expect(assigns(:user)).to eq(joe)
    end
    it "sets @queuings as @user queuings" do
      2.times { Fabricate(:queuing, user: joe, video: Fabricate(:video)) }
      get :show, id: joe.id
      expect(assigns(:queuings)).to eq(joe.queuings)
    end
    it "sets @reviews as @user reviews" do
      2.times { Fabricate(:review, user: joe) }
      get :show, id: joe.id
      expect(assigns(:reviews)).to eq(joe.reviews)
    end
    it_behaves_like "require sign in" do
      let(:action) { get :show, id: joe.id }
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end
    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
    it "sets @user with recipients email address" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: 'nwerkjhsoid'
      expect(response).to redirect_to expired_link_path
    end
  end
end