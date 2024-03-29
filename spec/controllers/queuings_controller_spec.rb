require 'spec_helper'

describe QueuingsController do
  context "with authenticated user" do
    let(:jack) { Fabricate(:user) }
    before { set_current_user(jack) }
    let(:video) { Fabricate(:video) }

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
      it "redirects to queuings index" do
        post :create, video_id: video.id
        expect(response).to redirect_to queuings_path
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

      context "not signed in" do
        it_behaves_like "require sign in" do
          let(:action) { post :create, video_id: video.id }
        end
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

      context "not signed in" do
        it_behaves_like "require sign in" do
          let(:action) { get :index }
        end
      end
    end

    describe "DELETE destroy" do
      let(:queuing) { Fabricate(:queuing, user_id: jack.id, video_id: video.id, position: 1) }
      
      it "destroys queuing item" do
        set_current_user(jack)
        delete :destroy, id: queuing.id
        expect(jack.queuings.count).to eq(0)
      end
      it "does not delete if queue item is not in current_user queue" do
        another_user = Fabricate(:user)
        set_current_user(another_user)
        delete :destroy, id: queuing.id
        expect(Queuing.first).to eq(queuing)
      end
      it "redirects to queuing page" do
        delete :destroy, id: queuing.id
        expect(response).to redirect_to queuings_path
      end
      it "normalizes queuing positions" do
        queuing2 = Fabricate(:queuing, user: current_user, position: 2)
        delete :destroy, id: queuing.id
        expect(queuing2.reload.position).to eq(1)
      end

      context "user not signed in" do
        it_behaves_like "require sign in" do
          let(:action) { delete :destroy, id: queuing.id }
        end
      end
    end
  end

  describe "PUT update_multiple" do
    before { set_current_user }

    context "with valid inputs" do
      let(:queuing1) {  Fabricate(:queuing, user: current_user, position: 1) }
      let(:queuing2) {  Fabricate(:queuing, user: current_user, position: 2) }
      let(:queuing3) {  Fabricate(:queuing, user: current_user, position: 3) }

      it "redirects to queuings_path" do
        put :update_multiple, queuing_updates: [{"id"=>queuing1.id, "position"=>"3"}, {"id"=>queuing2.id, "position"=>"2"}, {"id"=>queuing3.id, "position"=>"1"}]
        expect(response).to redirect_to queuings_path
      end
      it "updates positions of queuings with queuing_updates" do
        put :update_multiple, queuing_updates: [{"id"=>queuing1.id, "position"=>"3"}, {"id"=>queuing2.id, "position"=>"2"}, {"id"=>queuing3.id, "position"=>"1"}]
        expect(current_user.queuings).to eq([queuing3, queuing2, queuing1])
      end
      it "normalizes the position numbers" do
        put :update_multiple, queuing_updates: [{"id"=>queuing1.id, "position"=>"3"}, {"id"=>queuing2.id, "position"=>"2"}, {"id"=>queuing3.id, "position"=>"1"}]
        expect(current_user.queuings.map(&:position)).to match_array([1, 2, 3])
      end
    end
    context "with invalid inputs" do
      let(:queuing1) {  Fabricate(:queuing, user: current_user, position: 1) }
      let(:queuing2) {  Fabricate(:queuing, user: current_user, position: 2) }
      let(:queuing3) {  Fabricate(:queuing, user: current_user, position: 3) }

      it "redirects to queuings path" do
        put :update_multiple, queuing_updates: [{"id"=>queuing1.id, "position"=>"q"}, {"id"=>queuing2.id, "position"=>"1"}]
        expect(response).to redirect_to(queuings_path)
      end
      it "displays flash message with error" do
        put :update_multiple, queuing_updates: [{"id"=>queuing1.id, "position"=>"q"}, {"id"=>queuing2.id, "position"=>"1"}]
        expect(flash[:error]).to be_present
      end
      it "does not change the queuing positions" do
        put :update_multiple, queuing_updates: [{"id"=>queuing1.id, "position"=>"2"}, {"id"=>queuing2.id, "position"=>"q"}]
        expect(queuing1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated user" do
      it_behaves_like "require sign in" do
        let(:action) { put :update_multiple }
      end
    end

    context "with queuings that do not belong to the current user" do
      before { set_current_user }
      it "only updates queuings that belong to current user" do
        another_user = Fabricate(:user)
        queuing1 = Fabricate(:queuing, user: another_user, position: 1)
        queuing2 = Fabricate(:queuing, user: current_user, position: 2)
        put :update_multiple, queuing_updates: [{"id"=>"1", "position"=>"2"}, {"id"=>"2", "position"=>"1"}]
        expect(queuing1.reload.position).to eq(1)
      end
    end
  end
end