require "spec_helper"

feature "User interacts with queuings" do
	
	let(:molly) { Fabricate(:user, email: "molly@gmail.com", password: "password") }

	scenario "User adds videos to queue and reorders queuings" do
		comedies = Fabricate(:category)
		monk = Fabricate(:video, title: "Monk")
		monk.categories << comedies
		south_park = Fabricate(:video, title: "South Park")
		south_park.categories << comedies
		futurama = Fabricate(:video, title: "Futurama")
		futurama.categories << comedies

		sign_in_user
		
		add_video_to_queue(monk)
		page.should have_content(monk.title)
		
		visit video_path(monk)
		page.should_not have_link("+ My Queue")

		add_video_to_queue(south_park)
		add_video_to_queue(futurama)
		
		fill_position_field(monk, 3)
		fill_position_field(south_park, 1)
		fill_position_field(futurama, 2)
		click_button("Update Instant Queue")

		expect_video_position(monk, 3)
		expect_video_position(south_park, 1)
		expect_video_position(futurama, 2)
	end

	def add_video_to_queue(video)
		visit home_path
		click_on_video(video)
		click_link("+ My Queue")
	end

	def fill_position_field(video, position)
		fill_in "video_#{video.id}", with: position
	end

	def expect_video_position(video, position)
		find_field("video_#{video.id}").value.should eq "#{position}"
	end
end