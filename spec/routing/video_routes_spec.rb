require 'spec_helper'

describe "routing to videos" do
  it "routes /videos/search to videos#search" do
    { :post => "/videos/search" }.should route_to( "videos#search")
  end
end