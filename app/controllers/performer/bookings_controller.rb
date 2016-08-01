module Performer
  class BookingsController < Performer::BaseController

    before_filter :get_date, only: [:calendar]

    def index
      @bookings = current_user.received_bookings.recent.includes(:service, :event_type, :venue_type).page(params[:page])
    end

    def calendar
      @calendar = Bookings::Calendar.new(@date, current_user)
    end

    def accept
      @booking.accept!
      redirect_to performer_bookings_path, notice: t('.notice')
    end

    def decline
      @booking.decline!
      redirect_to performer_bookings_path, notice: t('.notice')
    end

    private

    def get_date
      @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now.to_date
    end
  end
end