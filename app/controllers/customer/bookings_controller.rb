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
      @booking.payments.build if @booking.payment? && !@booking.payments.any?
    end

    def update
      if params[:stripe_token].present?
        authorize
      elsif @booking.update(booking_params)
        case @booking.current_state
        when :address
          @booking.locate!
          redirect_to edit_customer_booking_path(@booking), notice: t('.notice')
        when :payment
          @booking.payment.first.authorize!
          redirect_to customer_bookings_path, notice: t('.notice')
        else
          redirect_to :back, alert: t('common.something_went_wrong')
        end
      else
        render :edit
      end
    end

    def destroy
      redirect_to :back, alert: t('common.not_allowed') and return unless @booking.destroyable?
      @booking.destroy
      redirect_to :back, notice: t('.notice')
    end

    def cancel
    end

    private

    def booking_params
      params.require(:booking).permit(
        :email, :event_type_id, :venue_type_id, :performer_id, :service_id, :start_at,
        :start_time, :end_time, :number_of_guests, :special_info,
        address_attributes: [:id, :first_name, :last_name, :address1, :address2, :phone, :country_id,
          :city, :state_name, :state_id, :zipcode],
        payments_attributes: [:id, :source_id, :source_type]
      ).merge(last_ip_address: request.remote_ip)
    end

    def load_resources
      @service = @booking.service || Service.find(params[:service_id])
      @performer = @service.try(:user)
    end

    def get_date
      @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now.to_date
    end

    def ensure_service
      redirect_to root_path, alert: t('common.something_went_wrong') and return unless @service
    end

    def ensure_bookable
      redirect_to service_path(@service), alert: t('common.book_unavailable') and return unless @performer&.payment_ready?
    end

    def authorize
      if (credit_card = CreditCard.from_stripe_token(params[:stripe_token], current_user)).persisted?
        if payment = @booking.payments.create(source: credit_card)
          payment.authorize!
          redirect_to customer_bookings_path, notice: t('.notice')
        else
          redirect_to :back, alert: payment.errors.full_messages.join(' ')
        end
      else
        redirect_to :back, alert: credit_card.errors.full_messages.join(' ')
      end
    end
  end
end