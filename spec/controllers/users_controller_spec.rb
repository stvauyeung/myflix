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