class HomeController < ApplicationController

  before_filter :load_categories, :tweak_price_params, only: [:search]
  
  def index
    @top_services = Service.top.includes(:category, :primary_image, performers: :profile)
  end

  def search
    @q = Service.open.active.search(params[:q])
    @q.sorts = 'rating desc' if @q.sorts.empty?

    @services = @q.result.includes(:category, :primary_image, performers: :profile).page(params[:page])
  end

  private

  def load_categories
    @categories = Category.select(:id, :name)
  end

  def tweak_price_params
    if params[:price_min].present?
      params[:q][:price_cents_gteq] = (params[:price_min].to_f * 100).to_i
    end

    if params[:price_max].present?
      params[:q][:price_cents_lteq] = (params[:price_max].to_f * 100).to_i
    end
  end
end
