class ServicesController < ApplicationController

  before_filter :load_categories, :tweak_price_params, :tweak_location, only: [:search]

  def search
    @q = Service.open.active.search(params[:q])
    @q.sorts = 'price_cents desc' if @q.sorts.empty?

    @services = @q.result.includes(:category, :primary_image, performers: :profile).page(params[:page])
  end

  def show
    
    @service = Service.find(params[:id])
    
    if @service.open
      @testimonials = @service.testimonials
      @similar_shows = Service.top_rated.where(category_id: @service.category_id).where.not(id: @service.id).limit(3)
    else
      redirect_to root_path, notice: 'Service not available.'
    end
    
  end

  private

  def tweak_price_params
    if params[:price_min].present?
      params[:q][:price_cents_gteq] = (params[:price_min].to_f * 100).to_i
    end

    if params[:price_max].present?
      params[:q][:price_cents_lteq] = (params[:price_max].to_f * 100).to_i
    end
  end

  def tweak_location
    if params[:q].present? && params[:q][:location_id_eq].present?
      unless params[:q][:location_id_eq] =~ /d+/
        if @location = Location.active.by_address(params[:q][:location_id_eq]).first
          params[:q][:location_id_eq] = @location.id
        end
      end
    end
  end
end
