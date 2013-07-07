require 'spec_helper'

describe "user routes" do
  it "routes /register to user#new" do
    { :get => "/register"}.should route_to(controller: "users", action: "new")
  end
end