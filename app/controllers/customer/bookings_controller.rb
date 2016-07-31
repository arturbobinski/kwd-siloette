module Customer
  class BookingsController < Customer::BaseController

    before_filter :load_resources, :get_date, only: [:new, :create, :edit, :update]
    before_filter :ensure_service, :ensure_bookable, only: [:new, :create, :edit, :update]

    def index
      @bookings = current_user.bookings.recent.includes(:service, :event_type, :venue_type).page(params[:page])
    end

    def new
      @calendar = Bookings::Calendar.new(@date, @performer)
    end

    def create
      @booking = current_user.bookings.new(booking_params)

      if @booking.save
        @booking.initiate!
        redirect_to edit_customer_booking_path(@booking), notice: t('.notice')
      else
        @calendar = Bookings::Calendar.new(@booking.start_at.to_date, @performer)
        render :new
      end
    end

    def edit
      @booking.address ||= Address.build_default
    end

    def update
      if @booking.update(booking_params)
        case @booking.aasm.current_state
        when :address
          @booking.locate!
          redirect_to edit_customer_booking_path(@booking), notice: t('.notice')
        when :payment
          @booking.preauthorize!
          redirect_to customer_bookings_path, notice: t('.notice')
        end
      else
        render :edit
      end
    end

    def destroy
    end

    private

    def booking_params
      params.require(:booking).permit(
        :email, :event_type_id, :venue_type_id, :performer_id, :service_id, :start_at,
        :start_time, :end_time, :number_of_guests, :special_info,
        address_attributes: [:id, :first_name, :last_name, :address1, :address2, :phone, :country_id,
          :city, :state_name, :state_id, :zipcode]
      )
    end

    def load_resources
      @service = @booking.service || Service.find(params[:service_id])
      @performer = @service.try(:user)
    end

    def get_date
      @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now.to_date
    end

    def ensure_service
      redirect_to :back, alert: t('common.something_went_wrong') and return unless @service
    end

    def ensure_bookable
      redirect_to :back, alert: t('common.book_unavailable') and return unless @performer&.payment_ready?
    end
  end
end