module Customer
  class BookingExtensionsController < Customer::BaseController

    before_filter :load_resources, :ensure_bookable, only: [:new, :create]

    def new
      redirect_to :back, alert: t('common.not_allowed') and return unless @booking.extendable?
      get_start_at
    end

    def create
      @booking_extension = @booking.extensions.new(booking_extension_params)

      if @booking_extension.save
        redirect_to customer_bookings_path, notice: t('.notice')
      else
        get_start_at
        render :new
      end
    end

    private

    def booking_extension_params
      params.require(:booking_extension).permit(:hours)
    end

    def load_resources
      @booking = current_user.bookings.find(params[:booking_id])
      @service = @booking.service
      @performer = @service.user
    end

    def ensure_bookable
      redirect_to root_path, alert: t('common.something_went_wrong') and return unless @booking.extendable?
    end

    def get_start_at
      @start_at = @booking.last_end_at.in_time_zone(user_time_zone)
      @calendar = Bookings::Calendar.new(@booking.last_end_at, @performer, user_time_zone)
    end
  end
end