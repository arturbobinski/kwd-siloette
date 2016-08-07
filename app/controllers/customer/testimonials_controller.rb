module Customer
  class TestimonialsController < Customer::BaseController

    before_filter :load_service, :check_ability

    def new
    end

    def create
      @testimonial = current_user.testimonials.new(testimonial_params.merge(service: @service, receiver: @service.user))

      if @testimonial.save
        redirect_to customer_bookings_path, notice: t('.notice')
      else
        render :new
      end
    end

    private

    def testimonial_params
      params.require(:testimonial).permit(:rating, :delay, :accuracy, :satisfaction, :text)
    end

    def load_service
      @service = Service.find(params[:service_id])
    end

    def check_ability
      unless @service.bookings.where(state: :completed, user: current_user).any?
        redirect_to customer_bookings_path, alert: t('common.not_allowed')
      end
    end
  end
end