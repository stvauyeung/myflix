require 'spec_helper'

describe UsersController do
  describe "GET #new" do
    context "non logged in user" do
      it "assigns a new user to @user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
      it "renders the :new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "logged in user" do
      before do
        User.create(name: "Joe", email:"joe@joe.com", password: "password")
        session[:user_id] = User.first.id
      end

      it "redirects current user to home path" do
        get :new
        expect(response).to redirect_to(home_path)
      end
    end
  end

  describe "POST #create" do
    it "creates a new instance of User" do
      post :create
      expect(assigns(:user)).to be_a_new(User)
    end

    context "with valid attributes" do
      it "saves new user in db" do
        expect{
          post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}
        }.to change(User, :count).by(1)
      end
      it "redirects to /home" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: "password"}
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid attribtues" do
      it "does not save new user in db" do
        expect{
          post :create, :user => {name: "Joe", email: "j@joe.com", password:""}
        }.to_not change(User, :count)
      end
      it "renders :new template" do
        post :create, :user => {name: "Joe", email: "j@joe.com", password: ""}
        expect(response).to render_template(:new)
      end
    end
  end
end