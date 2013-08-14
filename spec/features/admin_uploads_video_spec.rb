require 'spec_helper'

feature "Admin creates a video" do
	scenario "Admin adds video" do
		admin = Fabricate(:admin)
		comedy = Fabricate(:category, name: 'Comedy')

		sign_in_user(admin)

		click_link 'Add Video'
		page.should have_content 'Add a New Video'

		fill_in 'Title', with: 'Monk'
		fill_in 'Description', with: 'A detective named Monk'
		attach_file 'Large cover', 'spec/support/uploads/monk_large.jpg'
		attach_file 'Small cover', 'spec/support/uploads/monk.jpg'
		fill_in 'Video URL', with: 'http://www.youtube.com'
		click_button 'Add Video'
		page.should have_content 'You successfully added Monk.'

		click_link 'Sign Out'
		sign_in_user

		visit video_path(Video.first)
		page.should have_selector("img[src='/uploads/monk_large.jpg']")
		page.should have_selector("a[href='http://www.youtube.com']")
	end
end