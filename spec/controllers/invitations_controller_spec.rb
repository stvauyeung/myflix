require 'spec_helper'

describe InvitationsController do
	context "with signed in user" do
		let(:joe) { Fabricate(:user) }
		before { set_current_user(joe) }
		after { ActionMailer::Base.deliveries.clear }

		describe "GET new" do
			it "sets @invitation to new invitation" do
				get :new
				expect(assigns(:invitation)).to be_new_record
				expect(assigns(:invitation)).to be_instance_of(Invitation)
			end
			it_behaves_like "require sign in" do
				let(:action) { get :new }
			end
		end

		describe "POST create" do
			it_behaves_like "require sign in" do
				let(:action) { post :create, recipient_name: "Polly", recipient_email: "polly@pocket.com", message: "Join this shizz!"}
			end

			context "with valid input" do
				after { ActionMailer::Base.deliveries.clear }

				it "redirects to the invitation path" do
					post :create, invitation: { recipient_name: "Polly", recipient_email: "polly@pocket.com", message: "Join this shizz!" }
					expect(response).to redirect_to invitations_path
				end
				it "creates an invitation" do
					post :create, invitation: { recipient_name: "Polly", recipient_email: "polly@pocket.com", message: "Join this shizz!" }
					expect(Invitation.count).to eq(1)
				end
				it "sends an email to recipient" do
					post :create, invitation: { recipient_name: "Polly", recipient_email: "polly@pocket.com", message: "Join this shizz!" }
					message = ActionMailer::Base.deliveries.last
					message.to.should eq(["polly@pocket.com"])
				end
				it "sets the flash success message" do
					post :create, invitation: { recipient_name: "Polly", recipient_email: "polly@pocket.com", message: "Join this shizz!" }
					expect(flash[:success]).to be_present
				end
			end

			context "with invalid input" do
				it "renders new template" do
					post :create, invitation: { recipient_email: "polly@pocket.com", message: "Join this shizz!" }
					expect(response).to render_template :new
				end
				it "does not create an invitation" do
					post :create, invitation: { recipient_email: "polly@pocket.com", message: "Join this shizz!" }
					expect(Invitation.count).to eq(0)
				end
				it "does not send an email" do
					post :create, invitation: { recipient_email: "polly@pocket.com", message: "Join this shizz!" }
					expect(ActionMailer::Base.deliveries).to be_empty
				end
				it "sets flash error message" do
					post :create, invitation: { recipient_email: "polly@pocket.com", message: "Join this shizz!" }
					expect(flash[:error]).to be_present
				end
				it "sets @invitation" do
					post :create, invitation: { recipient_email: "polly@pocket.com", message: "Join this shizz!" }
					expect(assigns(:invitation)).to be_present
				end
			end
		end
	end
end