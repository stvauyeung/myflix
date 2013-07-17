require 'spec_helper'

describe QueuingsController do
  context "with authenticated user" do
    let(:current_user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    before { session[:user_id] = current_user.id }

    describe "POST create" do
      it "creates a new queuing" do
        post :create, video_id: video.id
        expect(Queuing.count).to eq(1)
      end
      it "creates queuing associated with user" do
        post :create, video_id: video.id
        expect(Queuing.first.user_id).to eq(current_user.id)
      end
      it "creates queuing assocated with video" do
        post :create, video_id: video.id
        expect(Queuing.first.video_id).to eq(video.id)
      end
      it "redirects to video page" do #may change to redirect to queuings_path
        post :create, video_id: video.id
        expect(response).to redirect_to video_path(video)
      end
      it "puts video as last in queue" do
        hulk = Fabricate(:video)
        Fabricate(:queuing, user: current_user, video: video)
        post :create, video_id: hulk.id
        hulk_queuing = Queuing.where(video_id: hulk.id, user_id: current_user.id).first
        expect(hulk_queuing.position).to eq(2)
      end
      it "should not add a video to queue if video is in queue" do
        Fabricate(:queuing, user: current_user, video: video)
        post :create, video_id: video.id
        expect(current_user.queuings.count).to eq(1)
      end
    end

    describe "GET index" do
      it "sets @user as current_user" do
        get :index
        expect(assigns[:user]).to eq(current_user)
      end
      it "sets @queuings as current_user.queuings" do
        get :index
        expect(assigns[:queuings]).to match_array(current_user.queuings)
      end
    end

    describe "DELETE destroy" do
      let(:queuing) { Fabricate(:queuing, user: current_user, video: video) }
      it "destroys queuing item" do
        delete :destroy, id: queuing.id
        expect(Queuing.count).to eq(0)
      end
      it "does not delete if queue item is not in current_user queue" do
        another_user = Fabricate(:user)
        session[:user_id] = another_user.id
        delete :destroy, id: queuing.id
        expect(Queuing.first).to eq(queuing)
      end
      it "redirects to queuing page" do
        delete :destroy, id: queuing.id
        expect(response).to redirect_to queuings_path
      end
    end
  end
  context "unauthenticated user" do
    let(:video) { Fabricate(:video) }
    let(:queuing) { Fabricate(:queuing) }
    describe "redirects to login path for POST create and GET index" do
      it "POST create" do
        post :create, video_id: video.id
        expect(response).to redirect_to login_path
      end
      it "GET index" do
        get :index
        expect(response).to redirect_to login_path
      end
      it "DELETE destroy" do
        delete :destroy, id: queuing.id
        expect(response).to redirect_to login_path
      end
    end
  end
end