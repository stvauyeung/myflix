require 'spec_helper'

describe VideosController do
  before { set_current_user }
  let(:video) { Fabricate(:video, title: "Futurama") }

  describe "GET show" do
    it "sets @video for authenticated user" do
      get :show, :id => video.id
      expect(assigns(:video)).to eq(video)
    end
    it "sets @reviews for authenticated user" do
      get :show, :id => video.id
      expect(assigns(:reviews)).to eq(video.reviews)
    end
    it_behaves_like "require sign in" do
      let(:action) { get :show, :id => Fabricate(:video).id }
    end
  end

  describe "POST search" do
    it "populates an array of videos for signed in user" do
      post :search, :q => "rama"
      expect(assigns[:videos]).to eq([video])
    end
    it_behaves_like "require sign in" do
      let(:action) { post :search, :q => "rama" }
    end
  end
end