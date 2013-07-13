require 'spec_helper'

describe Category do
  it { should have_many(:videos).through(:categorizations)}

  describe "#recent_videos" do
    before do
      3.times do
        Fabricate(:category)
      end
      
      4.times do
        v = Fabricate(:video)
        v.categories << Category.first
      end

      6.times do
        v = Fabricate(:video)
        v.categories << Category.last
      end
      
      v = Fabricate(:video, created_at: 2.days.ago)
      v.categories << Category.last
    end

    it "returns array of videos in category" do
      category = Category.find(1)
      expect(category.recent_videos).to match_array(Category.first.videos)
    end
    it "returns array with max 6 videos" do
      category = Category.find(3)
      expect(category.recent_videos.size).to eq(6)
    end
    it "returns the last 6 videos in reverse chron order" do
      category = Category.find(3)
      expect(category.recent_videos).to eq(Category.last.videos.order("created_at DESC").limit(6))
    end
    it "returns empty array on category with no videos" do
      category = Category.find(2)
      expect(category.recent_videos).to eq([])
    end
  end
end