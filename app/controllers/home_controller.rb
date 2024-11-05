class HomeController < ApplicationController
  def index
    flash[:notice] = "Welcome to the site!"
    flash[:alert] = "Alarm alarm"
  end
end
