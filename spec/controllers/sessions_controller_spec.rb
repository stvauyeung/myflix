require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new template for non logged in users" do
      session[:user_id] = nil
      get :new
      expect(response).to render_template(:new)
    end
    it "renders the home page for logged in users" do
      User.create(name: "Joe", email: "joe@joe.com", password: "password")
      session[:user_id] = User.first.id
      get :new
      response.should redirect_to(home_path)
    end
  end

  describe "POST create" do
    before do
      User.create(name: "Joe", email: "joe@joe.com", password: "password")
    end
    
    context "authenticated user" do
      it "redirects user to home path" do
        post :create, {email: "joe@joe.com", password: "password"}
        response.should redirect_to(home_path)
      end
      it "sets session user id" do
        post :create, {email: "joe@joe.com", password: "password"}
        session[:user_id].should be_true
      end
    end
    
    context "non authenticated user" do
      it "renders sign in path" do
        post :create, {email: "sam@sam.com", password: ""}
        expect(response).to render_template(:new)
      end
      it "does not set session user id" do
        post :create, {email: "sam@sam.com", password: ""}
        session[:user_id].should be_nil
      end
    end
  end

  describe "GET destroy" do
    it "sets session id to nil" do
      get :destroy
      session[:user_id].should be_nil
    end
  end
end