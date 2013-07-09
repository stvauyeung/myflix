require 'spec_helper'

describe VideosController do
  before do
    Video.create(title: "The Big Lebowski", description: "A 1998 comedy film written and directed by Joel and Ethan Coen")
    Video.create(title: "Big Fish", description: "Fantasy adventure film based on the 1998 novel of the same name by Daniel Wallace. ")
    Video.create(title: "Spiderman", description: "Fantasy adventure film based on the 1998 novel of the same name by Daniel Wallace. ")
      
    user = User.create(name: "joe", email: "j@j.com", password: "password")
    session[:user_id] = user.id
  end

  describe "GET show" do
    it "finds the right video from params id" do
      get :show, :id => 1
      expect(assigns(:video).title).to eq("The Big Lebowski")
    end
    it "renders the :show template" do
      get :show, :id => 1
      response.should render_template :show
    end
  end

  describe "POST search" do
    it "populates an array of videos" do
      post :search, :q => "big"
      expect(assigns[:videos]).to match_array([Video.find(1), Video.find(2)])
    end
    it "renders the :search view" do
      post :search, :q => ""
      expect(response).to render_template :search
    end
  end
end