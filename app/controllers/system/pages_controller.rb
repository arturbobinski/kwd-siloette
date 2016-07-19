module System
  class PagesController < System::BaseController
    
    def show
      unless params[:full].present?
        render layout: false
      end
    end
  end
end