require 'spec_helper'

describe Admin::VideosController do
	describe "GET new" do
		it_behaves_like "require sign in" do
			let(:action) { get :new }
		end

		it_behaves_like "require admin" do
			let(:action) { get :new }
		end

		it "sets @video to a new video" do
			set_current_admin
			get :new
			assigns(:video).should be_an_instance_of Video
			assigns(:video).should be_new_record
		end
		
		it "sets error flash message for normal user" do
			set_current_user
			get :new
			expect(flash[:error]).to be_present
		end
	end

	describe "POST create" do
		it_behaves_like "require sign in" do
			let(:action) { post :create }
		end

		it_behaves_like "require admin" do
			let(:action) { post :create }
		end

		context "with valid input" do
			it "redirects to add new video page" do
				category = Fabricate(:category)
				set_current_admin
				post :create, :video => { title: "Lion King", description: "Simba, Timone and Pumba.", categories: category.id }
				expect(response).to redirect_to new_admin_video_path
			end
			it "creates a video" do
				category = Fabricate(:category)
				set_current_admin
				post :create, :video => { title: "Lion King", description: "Simba, Timone and Pumba.", categories: category.id }
				expect(Video.count).to eq(1)
			end
			it "categorizes the video" do
				category = Fabricate(:category)
				set_current_admin
				post :create, :video => { title: "Lion King", description: "Simba, Timone and Pumba.", categories: category.id }
				expect(Video.last.categorizations.count).to eq(1)
			end
			it "sets the flash success message" do
				category = Fabricate(:category)
				set_current_admin
				post :create, :video => { title: "Lion King", description: "Simba, Timone and Pumba.", categories: category.id }
				expect(flash[:success]).to be_present
			end
		end
		context "with invalid input" do
			it "does not create a video" do
				category = Fabricate(:category)
				set_current_admin
				post :create, :video => { description: "Simba, Timone and Pumba.", categories: category.id }
				expect(Video.count).to eq(0)
			end
			it "renders the :new template" do
				category = Fabricate(:category)
				set_current_admin
				post :create, :video => { description: "Simba, Timone and Pumba.", categories: category.id }
				expect(response).to render_template(:new)
			end
			it "sets the @video variable" do
				category = Fabricate(:category)
				set_current_admin
				post :create, :video => { description: "Simba, Timone and Pumba.", categories: category.id }
				expect(assigns(:video)).to be_present
			end
			it "sets the flash error message" do
				category = Fabricate(:category)
				set_current_admin
				post :create, :video => { description: "Simba, Timone and Pumba.", categories: category.id }
				expect(flash[:error]).to be_present
			end
		end
	end
end