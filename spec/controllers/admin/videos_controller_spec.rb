require 'spec_helper'

describe Admin::VideosController do
	describe "GET new" do
		it_behaves_like "require sign in" do
			let(:action) { get :new }
		end
		it "sets @video to a new video" do
			set_current_admin
			get :new
			assigns(:video).should be_an_instance_of Video
			assigns(:video).should be_new_record
		end
		it "redirects normal user to home path" do
			set_current_user
			get :new
			response.should redirect_to home_path
		end
		it "sets error flash message for normal user" do
			set_current_user
			get :new
			expect(flash[:error]).to be_present
		end
	end
end