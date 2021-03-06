module Performer
  class BookingsController < Performer::BaseController

    before_filter :get_start_at, only: [:calendar]

    def index
      @bookings = current_user.received_bookings.recent
        .where(state: %w(pending accepted paid completed))
        .where(payment_state: %w(authorized processing completed))
        .includes(:service, :event_type, :venue_type, :extensions).page(params[:page])
    end

    def calendar
      @calendar = Bookings::Calendar.new(@start_at, current_user, user_time_zone)
    end

    def accept
      @booking.accept!
      redirect_to performer_bookings_path, notice: t('.notice')
    end

    def decline
      @booking.decline!
      redirect_to performer_bookings_path, notice: t('.notice')
    end
  end
end