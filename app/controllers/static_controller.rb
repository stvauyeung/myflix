class StaticController < ApplicationController
  def front
    if logged_in? == true
      redirect_to home_path
    end
  end
end