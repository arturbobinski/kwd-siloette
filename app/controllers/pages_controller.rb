class PagesController < ApplicationController
  
  def show
    @page = Page.find(params[:id])

    unless params[:full].present?
      render layout: false
    end
  end
end
