module Customer
  class BookingsController < Customer::BaseController

    before_filter :load_resources, only: [:new, :create, :edit, :update]
    before_filter :get_start_at, only: [:new]
    before_filter :ensure_service, :ensure_bookable, only: [:new, :create, :edit, :update]

    def index
      @bookings = current_user.bookings.recent.includes(:service, :event_type, :venue_type, :extensions).page(params[:page])
    end

    def new
      @calendar = Bookings::Calendar.new(@start_at, @performer, user_time_zone)
    end

    def create
      @booking = current_user.bookings.new(booking_params)

      if @booking.save
        @booking.locate!
        redirect_to edit_customer_booking_path(@booking), notice: t('.notice')
      else
        @calendar = Bookings::Calendar.new(@booking.start_at, @performer, user_time_zone)
        render :new
      end
    end

    def edit
      if params[:event].present?
        event = params[:event]
        @booking.send("#{event}!") if @booking.send("may_#{event}?")

        if event == 'schedule'
          now = user_time_zone.now
          @start_at = @booking.start_at.in_time_zone(user_time_zone)
          @start_at = now if @start_at < now
          @calendar = Bookings::Calendar.new(@booking.start_at, @performer, user_time_zone)
        end
      end
      @booking.address ||= current_user.addresses.recent.first || Address.build_default
      @booking.build_payment unless @booking.payment
    end

    def update
      if params[:stripe_token].present?
        authorize
      elsif @booking.update(booking_params)
        case @booking.current_state
        when :scheduling
          @booking.locate!
          redirect_to edit_customer_booking_path(@booking), notice: t('.notice')
        when :address
          @booking.checkout!
          redirect_to edit_customer_booking_path(@booking), notice: t('.notice')
        when :payment
          @booking.payment.authorize!
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
      redirect_to :back, alert: t('common.not_allowed') and return unless @booking.may_cancel?
      @booking.cancel!
      redirect_to :back, notice: t('.notice')
    end

    def complete
      redirect_to :back, alert: t('common.not_allowed') and return unless @booking.may_complete?
      @booking.complete!
      redirect_to new_customer_service_testimonial_path(service_id: @booking.service_id), notice: t('.notice')
    end

    private

    def booking_params
      params.require(:booking).permit(
        :email, :event_type_id, :venue_type_id, :performer_id, :service_id, :start_at,
        :start_time, :hours, :number_of_guests, :special_info, :entry_instructions, :parking_instructions,
        address_attributes: [:id, :first_name, :last_name, :address1, :address2, :phone, :country_id,
          :city, :country_code, :state_name, :state_id, :zipcode, :dob],
        payment_attributes: [:id, :source_id, :source_type]
      ).merge(last_ip_address: request.remote_ip)
    end

    def load_resources
      @service = @booking.service || Service.find(params[:service_id])
      @performer = @service.try(:user)
    end

    def ensure_service
      redirect_to root_path, alert: t('common.something_went_wrong') and return unless @service
    end

    def ensure_bookable
      redirect_to service_path(@service), alert: t('common.book_unavailable') and return unless @performer&.payment_ready?
    end

    def authorize
      if (credit_card = CreditCard.from_stripe_token(params[:stripe_token], current_user)).persisted?
        if payment = @booking.create_payment(source: credit_card)
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