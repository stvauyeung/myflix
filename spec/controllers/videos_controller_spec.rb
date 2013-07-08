require 'spec_helper'

describe VideosController do
  before do
    lebowski = Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
    fish = Video.create(title: "Big Fish", description: "Fantasy adventure film based on the 1998 novel of the same name by Daniel Wallace. ")
      
    user = User.create(name: "joe", email: "j@j.com", password: "password")
    session[:user_id] = user.id
  end

  describe "#search" do
    it "populates an array of videos" do
      post :search, :q => "big"
      expect(assigns[:videos]).to match_array(Video.search_by_title("big"))
    end
    it "renders the :search view" do
      post :search, :q => ""
      expect(response).to render_template :search
    end
  end
end