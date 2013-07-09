require 'spec_helper'

describe Category do
  it { should have_many(:videos).through(:categorizations)}

  describe "#recent_videos" do
    before do
      Category.create(name: "Comedy")
      Category.create(name: "Romance")
      Category.create(name: "Action")

      Video.create(title: "Title 1", description: "A comedy")
      Video.last.categories << Category.first
      Video.create(title: "Title 2", description: "A comedy")
      Video.last.categories << Category.first
      Video.create(title: "Title 3", description: "A comedy")
      Video.last.categories << Category.first
      Video.create(title: "Title 4", description: "A comedy")
      Video.last.categories << Category.first

      Video.create(title: "Title 5", description: "A thriller")
      Video.last.categories << Category.last
      Video.create(title: "Title 6", description: "A thriller")
      Video.last.categories << Category.last
      Video.create(title: "Title 7", description: "A thriller")
      Video.last.categories << Category.last
      Video.create(title: "Title 8", description: "A thriller")
      Video.last.categories << Category.last
      Video.create(title: "Title 9", description: "A thriller")
      Video.last.categories << Category.last
      Video.create(title: "Title 10", description: "A thriller")
      Video.last.categories << Category.last
      Video.create(title: "Title 11", description: "A thriller", created_at: 2.days.ago)
      Video.last.categories << Category.last
    end

    it "returns array of videos in category" do
      category = Category.find(1)
      expect(category.recent_videos).to match_array([Video.find(4), Video.find(3), Video.find(2), Video.find(1)])
    end
    it "returns array with max 6 videos" do
      category = Category.find(3)
      expect(category.recent_videos.size).to eq(6)
    end
    it "returns the last 6 videos in reverse chron order" do
      category = Category.find(3)
      expect(category.recent_videos).to eq([Video.find(10), Video.find(9), Video.find(8), Video.find(7), Video.find(6), Video.find(5)])
    end
    it "returns empty array on category with no videos" do
      category = Category.find(2)
      expect(category.recent_videos).to eq([])
    end
  end
end