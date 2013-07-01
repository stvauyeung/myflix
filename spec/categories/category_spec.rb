require 'spec_helper'

describe Category do
  it "saves to database" do
    cat = Category.new(name: "Comedy")
    cat.save
    Category.first.name.should == "Comedy"
  end

  it "has many videos" do
    video = Video.new(title: "Mission Impossible", description: "This mission, should you choose to accept it...", small_cover_url: "/tmp/breaking_bad.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
    video.save
    video2 = Video.new(title: "Jurrasic Park", description: "Secret dinosaur island.  You know someone's going to get hurt.", small_cover_url: "/tmp/breaking_bad.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
    video2.save

    category = Category.create(name: "SciFi")
    category.videos << video
    category.videos << video2

    category.videos.size.should == 2
  end
end