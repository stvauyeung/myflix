require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with authenticated user" do
      before { set_current_user }
      let(:video) { Fabricate(:video) }
      
      context "with valid inputs" do
        it "redirects to video show page" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(response).to redirect_to video_path(video)
        end
        it "creates review" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.count).to eq(1)
        end
        it "creates review associated with the video" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(video.reviews.count).to eq(1)
        end
        it "creates review associated with the user" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid inputs" do
        it "does not create review" do
          post :create, review: { rating: 5, content: "" }, video_id: video.id
          expect(Review.count).to eq(0)
        end
        it "renders the video/show template" do
          post :create, review: { rating: 5, content: "" }, video_id: video.id
          expect(response).to render_template 'videos/show'
        end
        it "sets @video" do
          post :create, review: { rating: 5, content: "" }, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end
        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          post :create, review: { rating: 5, content: "" }, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end
    
    it_behaves_like "require sign in" do
      let(:action) { post :create, review: Fabricate.attributes_for(:review), video_id: Fabricate(:video).id }
    end
  end
end