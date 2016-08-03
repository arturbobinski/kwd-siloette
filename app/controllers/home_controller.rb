class HomeController < ApplicationController

  def index
    @top_services = Service.top_rated.limit(4).includes(:category, :primary_image, performers: :profile)
  end

  def work_with_us
  end
end
