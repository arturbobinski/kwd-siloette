module System
  class PagesController < System::BaseController

    skip_before_filter :authenticate_user!, only: [:show]
    
    def show
      if params[:md].present?
        render layout: false
      end
    end
  end
end