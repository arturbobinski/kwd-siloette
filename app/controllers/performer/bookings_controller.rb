module Performer
  class BookingsController < Performer::BaseController

    before_filter :get_date, only: [:calendar]

    def calendar
      @calendar = Bookings::Calendar.new(@date, current_user)
    end

    private

    def get_date
      @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now.to_date
    end
  end
end