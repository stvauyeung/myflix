require 'spec_helper'

describe Video do
  it { should have_many(:categories).through(:categorizations) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#search_by_title" do
    it "returns empty array if no matches found" do
      results = Video.search_by_title("Big")
      results.size.should eq(0)
    end
    it "returns array size one if one match found" do
      Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
      results = Video.search_by_title("Big")
      results.size.should eq(1)
    end
    it "returns array size n if n matches found" do
      Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
      Video.create(title: "Big Fish", description: "Fantasy adventure film based on the 1998 novel of the same name by Daniel Wallace. ")
      results = Video.search_by_title("big")
      results.size.should eq(2)
    end
  end
end