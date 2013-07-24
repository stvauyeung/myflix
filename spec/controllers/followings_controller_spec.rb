require 'spec_helper'

describe FollowingsController do
	before { set_current_user }
	describe "GET index" do
		it "sets @followings as user followings" do
			get :index
			expect(assigns[:followings]).to eq(current_user.followings)
		end
	end
end