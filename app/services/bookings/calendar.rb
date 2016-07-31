module Bookings
  class Calendar

    def initialize(date, performer)
      @date, @performer = date, performer
    end

    def available_slots
      if schedule = @performer.schedules.active.find_by(wday: @date.wday)
        slots = []
        bookings.each do |booking|
          slots += (booking.start_at.hour..(booking.end_at.hour - 1)).to_a
        end
        slots += reservations.map { |x| x.start_at.hour }
        (schedule.start_slot..schedule.end_slot).to_a - slots.uniq
      else
        []
      end
    end

    def bookings
      @bookings ||= @performer.received_bookings.by_date(@date)
    end

    def reservations
      @reservations ||= @performer.reservations.by_date(@date)
    end
  end
end
