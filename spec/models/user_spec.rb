require 'spec_helper'

describe User do
  it { should validate_presence_of(:name)}

  it { should validate_presence_of(:email)}
  it { should validate_uniqueness_of(:email)}
  it { should_not allow_value("jaol").for(:email)}
  it { should allow_value("j@aol.com").for(:email)}

  it { should validate_presence_of(:password_digest) }

  it { should have_many(:queuings).order(:position) }
  it { should have_many(:reviews) }

  it { should have_many(:followings) }
  it { should have_many(:followers).through(:followings)}

  describe "#in_queuings?" do
  	it "returns true if video is in user queuings" do
  		user = Fabricate(:user)
  		video = Fabricate(:video)
  		Fabricate(:queuing, user: user, video: video)
  		user.in_queuings?(video).should be_true
  	end
  	it "returns false if video is not in user queuings" do
  		user = Fabricate(:user)
  		video = Fabricate(:video)
  		user.in_queuings?(video).should be_false
  	end
  end
  describe "#is_following" do
    it "returns all followings where user is the follower" do
      bob = Fabricate(:user)
      molly = Fabricate(:user)
      joe = Fabricate(:user)
      f1 = Fabricate(:following, follower_id: bob.id, user_id: molly.id)
      f2 = Fabricate(:following, follower_id: bob.id, user_id: joe.id)
      f3 = Fabricate(:following, follower_id: molly.id, user_id: bob.id)
      bob.is_following.should match_array([f1, f2])
    end
  end

  describe "#follows?" do
    let(:bob) { Fabricate(:user) }
    let(:molly) { Fabricate(:user) }
    before { Fabricate(:following, user: bob, follower: molly) }
    it "returns true of user is following" do
      molly.follows?(bob).should be_true
    end
    it "returns false if user not following " do
      bob.follows?(molly).should be_false
    end
  end
end