require 'spec_helper'

describe Following do
	it { should belong_to(:user) }
	it { should belong_to(:follower).class_name('User') }

	describe "#user_name" do
		it "returns the name of followed user" do
			bob = Fabricate(:user, name: "bob")
			following = Fabricate(:following, user_id: bob.id)
			expect(following.user_name).to eq("bob")
		end
	end
	describe "#user_queue" do
		it "returns the number of queuings of followed user" do
			bob = Fabricate(:user, name: "bob")
			2.times { Fabricate(:queuing, user: bob) }
			following = Fabricate(:following, user_id: bob.id)
			expect(following.user_queue).to eq(2)
		end
	end
	describe "#user_followers" do
		it "returns the number of followings of followed user" do
			bob = Fabricate(:user, name: "bob")
			2.times { Fabricate(:following, user: bob) }
			following = Fabricate(:following, user_id: bob.id)
			expect(following.user_followers).to eq(3)
		end
	end
end