require 'spec_helper'

describe Category do
  it { should have_many(:videos).through(:categorizations)}

  describe "#recent_videos" do
    before :each do
      Category.create(name: "Comedy")
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
      Video.create(title: "Title 11", description: "A thriller")
      Video.last.categories << Category.last
    end

    it "returns array of videos in category" do
      category = Category.find(1)
      expect(category.recent_videos).to eq [Video.find(4), Video.find(3), Video.find(2), Video.find(1)]
    end
    it "returns array with max 6 videos" do
      category = Category.find(2)
      expect(category.recent_videos.size).to eq(6)
    end
    it "returns the last 6 videos" do
      category = Category.find(2)
      expect(category.recent_videos).to eq [Video.find(11), Video.find(10), Video.find(9), Video.find(8), Video.find(7), Video.find(6)]
    end
  end
end