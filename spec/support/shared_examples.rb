shared_examples "require sign in" do
	it "redirects to login path" do
		clear_current_user
    action
		response.should redirect_to login_path
	end
end

shared_examples "require admin" do
	it "redirects normal user to home path" do
		set_current_user
		action
		response.should redirect_to home_path
	end
end

shared_examples "tokenable" do
	it "generates token on create" do
		object.token.should be_present
	end
end