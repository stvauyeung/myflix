require 'spec_helper'

describe "session routes" do
  it "routes get /login to sessions#new" do
    {:get => "/login"}.should route_to(controller: "sessions", action: "new")
  end
  it "routes post /login to sessions#create" do
    {:post => "/login"}.should route_to(controller: "sessions", action: "create")
  end
  it "routes /logout to sessions#destroy" do 
    {:get => "/logout"}.should route_to(controller: "sessions", action: "destroy")
  end
end