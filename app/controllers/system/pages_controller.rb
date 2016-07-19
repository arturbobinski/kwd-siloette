module System
  class PagesController < System::BaseController
    
    def show
      if params[:md].present?
        render layout: false
      end
    end
  end
end