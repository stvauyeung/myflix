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
end