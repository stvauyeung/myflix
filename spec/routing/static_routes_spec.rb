require 'spec_helper'

describe "static routes" do
  it "should route '/' to static#front" do
    { :get => "/" }.should route_to(:controller => "static", :action => "front")
  end
end