require 'spec_helper'

describe QueuingsController do
  context "with authenticated user"
    describe "POST create"
      it "creates a new queuing" do
        post :create, :queuing => Fabricate(:queuing)
        expect(Queuing.count).to eq(1)
      end
      it "creates queuing associated with user"
      it "creates queuing assocated with video"
      it "redirects to user queue page"
    describe "GET show"
  context "with unauthenticated user"
end