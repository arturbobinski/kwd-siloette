module System
  class PagesController < System::BaseController
    
    def show
      @page = Page.find(params[:id])

      unless params[:full].present?
        render layout: false
      end
    end
  end
end