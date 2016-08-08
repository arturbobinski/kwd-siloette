class LocationsController < ApplicationController

  def show
    @location = Location.by_address(params[:id]).first
    if @location
      @q = Service.open.active.search({location_id_eq: @location.id})
      @q.sorts = 'rating desc'

      @services = @q.result.includes(:category, :primary_image, performers: :profile).page(params[:page])
    end
  end
end
