def set_current_user(a_user=nil)
	user = (a_user || Fabricate(:user))
	session[:user_id] = user.id 
end

def current_user
	User.find(session[:user_id])
end

def clear_current_user
	session[:user_id] = nil
end

def sign_in_user(a_user=nil)
	user = (a_user || Fabricate(:user))
	visit "/login"
	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
	click_button "Login"
	expect(page).to have_content "Welcome back"
end