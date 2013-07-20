require 'spec_helper'

describe Queuing do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

  describe "#video_title" do
    it "returns title of associated video" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queuing = Queuing.create(user: user, video: video)
      expect(queuing.video_title).to eq(video.title)
    end
  end

  describe "#rating" do
    it "returns the user's rating of video if rated" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 3)
      queuing = Queuing.create(user: user, video: video)
      expect(queuing.rating).to eq(3)
    end
    it "returns nil if video not rated by user" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queuing = Queuing.create(user: user, video: video)
      expect(queuing.rating).to eq(nil)
    end
  end

  describe "#rating=" do
    it "changes the rating of review if review is present" do
      video = Fabricate(:video)
      bob = Fabricate(:user)
      review = Fabricate(:review, user: bob, video: video, rating: 2)
      queuing = Fabricate(:queuing, user: bob, video: video)
      queuing.rating = 4
      expect(Review.first.rating).to eq(4)
    end
    it "clears the rating of review if review is present" do
      video = Fabricate(:video)
      bob = Fabricate(:user)
      review = Fabricate(:review, user: bob, video: video, rating: 2)
      queuing = Fabricate(:queuing, user: bob, video: video)
      queuing.rating = nil
      expect(Review.first.rating).to be_nil
    end
    it "creates the rating of review if review not present" do
      video = Fabricate(:video)
      bob = Fabricate(:user)
      queuing = Fabricate(:queuing, user: bob, video: video)
      queuing.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end

  describe "#category_name" do
    it "returns the category name of queuing video" do
      video = Fabricate(:video)
      category = Fabricate(:category)
      video.categories << category
      queuing = Queuing.create(video: video)
      expect(queuing.category_name).to eq(category.name)
    end
  end

  describe "#category" do
    it "returns the category of queuing video" do
      video = Fabricate(:video)
      category = Fabricate(:category)
      video.categories << category
      queuing = Queuing.create(video: video)
      expect(queuing.category).to eq(category)
    end
  end
end