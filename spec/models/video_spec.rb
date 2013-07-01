require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "Breakfast at Tiffany's", description: "Every college girl has this movie poster", small_cover_url: "/tmp/breaking_bad.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
    video.save
    Video.first.title.should == "Breakfast at Tiffany's"
  end

  it "has category associations" do
    video = Video.new(title: "Mission Impossible", description: "This mission, should you choose to accept it...", small_cover_url: "/tmp/breaking_bad.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
    video.save
    category = Category.create(name: "SciFi")
    video.categories << category
    video.categories.first.name.should == "SciFi"
  end

  it "requires a title" do
    video = Video.new(title: "", description: "This mission, should you choose to accept it...", small_cover_url: "/tmp/breaking_bad.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
    video.should_not be_valid
  end

  it "requires a description" do
    video = Video.new(title: "Jurrasic Park", description: "", small_cover_url: "/tmp/breaking_bad.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
    video.should_not be_valid
  end
end