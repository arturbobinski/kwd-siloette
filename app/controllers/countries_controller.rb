class CountriesController < ApplicationController

  def show
    @country = Country.find(params[:id])
    @q = Service.open.active.search({ location_country_cont: @country.name })
    @q.sorts = 'rating desc'

    @services = @q.result.includes(:category, :primary_image, performers: :profile).page(params[:page])
  end
end
