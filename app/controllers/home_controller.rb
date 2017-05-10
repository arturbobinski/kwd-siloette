class HomeController < ApplicationController

  skip_before_filter :check_verified
  before_filter :load_categories

  def index
    @q = Service.open.active.search(params[:q])
    @top_services = Service.top_rated.limit.includes(:category, :primary_image, performers: :profile)
  end

  def work_with_us
  end
end
