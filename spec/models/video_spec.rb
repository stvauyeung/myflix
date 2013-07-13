require 'spec_helper'

describe Video do
  it { should have_many(:categories).through(:categorizations) }
  it { should have_many(:reviews).order("created_at DESC") }
  
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#search_by_title" do
    let(:subject) { Video.search_by_title("big") }
    
    context "no matches found" do
      before { Video.create(title: "Ghost Busters", description: "Who you gonna call") }
      it { should eq([]) }
    end

    context "one match found" do
      before do
        Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
        Video.create(title: "Ghost Busters", description: "Who you gonna call")
      end
      it { expect(subject.size).to eq(1) }
    end

    it "returns array of all matches ordered by created_at" do
      lebowski = Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
      fish = Video.create(title: "Big Fish", description: "Fantasy adventure film based on the 1998 novel of the same name by Daniel Wallace. ")
      subject.should eq([fish, lebowski])
    end
      
    it "returns an empty array for empty search" do
      Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
      Video.create(title: "Big Fish", description: "Fantasy adventure film based on the 1998 novel of the same name by Daniel Wallace. ")
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe "#average_rating" do
    let(:video) { Fabricate(:video) }
    let(:subject) { video.average_rating }
    let(:r1) { Fabricate(:review) }
    let(:r2) { Fabricate(:review) }
    it "returns 'not rated' if no ratings" do
      subject.should eq("Not Rated")
    end
    it "returns rating if one review" do
      video.reviews << r1
      subject.should eq(r1.rating)
    end
    it "returns average of ratings if multiple reviews" do
      video.reviews << [r1, r2]
      subject.should eq((r1.rating + r2.rating)/2)
    end
  end
end