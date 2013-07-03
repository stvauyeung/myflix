require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "Breakfast at Tiffany's", description: "Every college girl has this movie poster", small_cover_url: "/tmp/breaking_bad.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
    video.save
    Video.first.title.should == "Breakfast at Tiffany's"
  end

  it { should have_many(:categories).through(:categorizations) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it { should validate_presence_of(:description) }
end