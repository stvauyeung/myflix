require 'spec_helper'

describe Category do
  it "saves to database" do
    cat = Category.new(name: "Comedy")
    cat.save
    Category.first.name.should == "Comedy"
  end

  it { should have_many(:videos).through(:categorizations)}
end