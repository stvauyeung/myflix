require 'spec_helper'

describe VideosController do
  let(:video) { Fabricate(:video, title: "Futurama") }

  describe "GET show" do
    it "sets @video for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      get :show, :id => video.id
      expect(assigns(:video)).to eq(video)
    end
    it "sets @reviews for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      get :show, :id => video.id
      expect(assigns(:reviews)).to eq(video.reviews)
    end
    it "redirects to login path for unauthenticated user" do
      get :show, :id => video.id
      expect(response).to redirect_to(login_path)
    end
  end

  describe "POST search" do
    it "populates an array of videos for signed in user" do
      session[:user_id] = Fabricate(:user).id
      post :search, :q => "rama"
      expect(assigns[:videos]).to eq([video])
    end
    it "redirects to login path for non signed in user" do
      post :search, :q => "rama"
      expect(response).to redirect_to(login_path)
    end
  end
end