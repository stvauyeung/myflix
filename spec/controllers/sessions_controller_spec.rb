require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new template for non logged in users" do
      get :new
      expect(response).to render_template(:new)
    end
    it "renders the home page for logged in users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      response.should redirect_to(home_path)
    end
  end

  describe "POST create" do
    context "authenticated user" do
      before do
        joe = Fabricate(:user)
        post :create, { email: joe.email, password: joe.password }
      end
      it "redirects user to home path" do
        response.should redirect_to(home_path)
      end
      it "sets session user id" do
        session[:user_id].should be_true
      end
    end
    
    context "non authenticated user" do
      before do
        sam = Fabricate(:user)
        post :create, { email: sam.email, password: sam.password + '123'}
      end

      it "renders sign in path" do
        expect(response).to render_template(:new)
      end
      it "does not set session user id" do
        session[:user_id].should be_nil
      end
      it "flashes an error" do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    it "sets session id to nil" do
      session[:user_id].should be_nil
    end
    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end
    it "flashes notice" do
      expect(flash[:notice]).not_to be_blank
    end
  end
end