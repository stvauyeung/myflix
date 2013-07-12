require 'spec_helper'

describe ReviewsController do
  let(:video) { Fabricate(:video) }
  let(:user) { Fabricate(:user) }
  before { session[:user_id] = user.id }
  
  describe "GET new" do
    before { get :new, :video_id => video.id }
    it { expect(assigns(:video)).to eq(video) }
    it { expect(assigns(:review)).to be_a_new(Review) }
  end

  describe "POST create" do
    context "before save" do
      before { get :new, :video_id => video.id }
      it { expect(assigns(:video)).to eq(video) }
      it { expect(assigns(:review)).to be_a_new(Review) }
    end

    context "valid review" do
      before { post :create, :video_id => video.id, :review => {:content => "A review", :rating => 3} }
      it { expect(Review.count).to eq(1) }
      it { expect(video.reviews.count).to eq(1) }
      it { expect(Review.first.user).to eq(user) }
      it { response.should redirect_to(video_path(video)) }
      it { expect(Review.first.rating).to eq(3) }
    end

    context "invalid review" do
      before { post :create, :video_id => video.id, :review => { :content => "" } }
      it "does not save new review in db" do
        expect(Review.count).to eq(0)
      end
      it "redirects to video path" do
        response.should redirect_to(video_path(video))
      end
    end
  end
end