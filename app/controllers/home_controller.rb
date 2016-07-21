class HomeController < ApplicationController
  
  def index
    @top_services = Service.top.includes(:category, :primary_image, performers: :profile)
  end

  def search
    @services = Service.includes(:category, :primary_image, performers: :profile)
  end
end
