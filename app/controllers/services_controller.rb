class ServicesController < ApplicationController

  before_filter :load_categories, :tweak_price_params, only: [:search]

  def search
    @q = Service.open.active.search(params[:q])
    @q.sorts = 'rating desc' if @q.sorts.empty?

    @services = @q.result.includes(:category, :primary_image, performers: :profile).page(params[:page])
  end

  def show
    @service = Service.find(params[:id])
    @testimonials = @service.testimonials
    @similar_shows = Service.top_rated.where(category_id: @service.category_id).where.not(id: @service.id).limit(3)
  end

  private

  def load_categories
    @categories = Category.female.select(:id, :name)
  end

  def tweak_price_params
    if params[:price_min].present?
      params[:q][:price_cents_gteq] = (params[:price_min].to_f * 100).to_i
    end

    if params[:price_max].present?
      params[:q][:price_cents_lteq] = (params[:price_max].to_f * 100).to_i
    end
  end

  def check_location
    if params[:q].present? && params[:q][:location_address_cont].present?
      if (location_id = params[:q][:location_address_cont]).in?(AppConfig.implemented_locations.keys)
        redirect_to location_path(location_id)
      end
    end
  end
end
