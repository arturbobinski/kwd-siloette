class PagesController < ApplicationController

  def show
    @page = Page.find(params[:id])

    if params[:md].present?
      render layout: false
    end
  end
end
