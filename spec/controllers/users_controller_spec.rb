require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns a new user to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    context "successful registration" do
      it "redirects to /home" do
        result = double(:registration_result, successful?: true)
        Registration.any_instance.should_receive(:sign_up).and_return(result)
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}
        expect(response).to redirect_to home_path
      end
    end
    context "failed registration" do
      before do
        result = double(:registration_result, successful?: false, error_message: "Error Message")
        Registration.any_instance.should_receive(:sign_up).and_return(result)
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