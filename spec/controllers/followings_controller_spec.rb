require 'spec_helper'

describe FollowingsController do
	before { set_current_user }
	describe "GET index" do
		it "sets @followings as user followings" do
			get :index
			expect(assigns[:followings]).to eq(current_user.is_following)
		end
		it_behaves_like "require sign in" do
			let(:action) {get :index}
		end
	end
	describe "DELETE destroy" do
		let(:peter) { Fabricate(:user) }
		let(:following) { Fabricate(:following, follower: peter)}
		it "destroys the following if follower is current_user" do
			set_current_user(peter)
			delete :destroy, id: following.id
			expect(Following.count).to eq(0)
		end
		it "does not destroy following if follower is not current_user" do
			bob = Fabricate(:user)
			set_current_user(bob)
			delete :destroy, id: following.id
			expect(Following.count).to eq(1)
		end
	end

	describe "POST create" do
		let(:bob) { Fabricate(:user) }
		let(:joe) { Fabricate(:user) }
		before { set_current_user(bob) }
		it "creates a new followings" do
			post :create, user_id: joe.id
			expect(Following.count).to eq(1)
		end
		it "sets current user as follower" do
			post :create, user_id: joe.id
			expect(Following.first.follower).to eq(bob)
		end
		it_behaves_like "require sign in" do
			let(:action) { post :create, user_id: joe.id}
		end
	end
end