require 'spec_helper'

feature "User follows another user" do
	let(:molly) { Fabricate(:user) }

	scenario "Molly follows another user then unfollows that user" do
		joe = Fabricate(:user)
		action = Fabricate(:category, name: "Action")
		archer = Fabricate(:video)
		archer.categories << action
		Fabricate(:review, user: joe, video: archer)

		sign_in_user(molly)
		click_video(archer)
		click_profile_link(joe)

		click_button('Follow')
		page.should have_content("People I Follow")

		unfollow_user(joe, molly)
	end

	def click_video(video)
		find("a[href='/videos/#{video.id}']").click
		page.should have_content(video.title)
	end

	def click_profile_link(user)
		find_link(user.name).click
		page.should have_content("#{user.name}'s video collections")
	end

	def unfollow_user(user, follower)
		following = Following.where(user_id: user.id, follower_id: follower.id).first.id
		find("a[href='/followings/#{following}']").click
		page.should_not have_content("#{user.name}")
	end
end