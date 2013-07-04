require 'spec_helper'

describe VideosController do
  describe "#search" do
    before :each do
      Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
      Video.create(title: "Big Fish", description: "Fantasy adventure film based on the 1998 novel of the same name by Daniel Wallace. ")
    end

    it "populates an array of videos" do
      get 'search', :q => "big"
      expect(assigns(:videos)).to match_array(Video.search_by_title("big"))
    end
    it "renders the :search view" do
      get 'search', :q => ""
      expect(response).to render_template :search
    end
  end
end