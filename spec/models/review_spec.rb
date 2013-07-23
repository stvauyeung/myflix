require 'spec_helper'

describe Review do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:content) }
  it { should ensure_inclusion_of(:rating).in_array((1..5).to_a) }

  describe "#video_title" do
  	it "returns the title of associated video" do
  		video = Fabricate(:video)
  		user = Fabricate(:user)
  		review = Fabricate(:review, user: user, video: video)
  		expect(review.video_title).to eq(video.title)
  	end
  end
end