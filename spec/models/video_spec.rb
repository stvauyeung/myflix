require 'spec_helper'

describe Video do
  it { should have_many(:categories).through(:categorizations) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#search_by_title" do
    it "returns empty array if no matches found" do
      Video.create(title: "Ghost Busters", description: "Who you gonna call")
      results = Video.search_by_title("Big")
      results.size.should eq(0)
    end
    it "returns array size one if partial match found" do
      Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
      Video.create(title: "Ghost Busters", description: "Who you gonna call")
      results = Video.search_by_title("big")
      results.size.should eq(1)
    end
    it "returns array of one if exact match found" do
      Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
      Video.create(title: "Big Fish", description: "Fantasy adventure film based on the 1998 novel of the same name by Daniel Wallace. ")
      results = Video.search_by_title("the big lebowski")
      results.size.should eq(1)
    end
    it "returns array of all matches ordered by created_at" do
      lebowski = Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
      fish = Video.create(title: "Big Fish", description: "Fantasy adventure film based on the 1998 novel of the same name by Daniel Wallace. ")
      results = Video.search_by_title("big")
      results.should eq([fish, lebowski])
    end
    it "returns an empty array for empty search" do
      Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
      Video.create(title: "Big Fish", description: "Fantasy adventure film based on the 1998 novel of the same name by Daniel Wallace. ")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end