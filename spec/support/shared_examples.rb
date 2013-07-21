shared_examples "require sign in" do
	it "redirects to login path" do
		clear_current_user
    action
		response.should redirect_to login_path
	end
end