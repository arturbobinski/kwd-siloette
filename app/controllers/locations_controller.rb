class LocationsController < ApplicationController

  def show
    @county = AppConfig.implemented_locations[params[:id]]
    @q = Service.open.active.search({location_address_cont: @county})
    @q.sorts = 'rating desc'

    @services = @q.result.includes(:category, :primary_image, performers: :profile).page(params[:page])
  end
end
