module Bookings
  class Calendar

    def initialize(start_at, performer, time_zone)
      @start_at, @performer, @time_zone = start_at, performer, time_zone
      @start_at_in_zone = local_time(@start_at)
    end

    def available_slots
      if schedule = @performer.schedules.active.find_by(wday: @start_at_in_zone.wday)
        slots = []
        bookings.each do |booking|
          slots += (local_time(booking.start_at).hour..(local_time(booking.end_at).hour - 1)).to_a
        end
        slots += reservations.map { |x| local_time(x.start_at).hour }

        if @start_at_in_zone.to_date == @time_zone.today
          slots += (0..@start_at_in_zone.hour).to_a
        end

        (schedule.start_slot..schedule.end_slot).to_a - slots.uniq
      else
        []
      end
    end

    def bookings
      @bookings ||= @performer.received_bookings.by_date(@start_at)
    end

    def reservations
      @reservations ||= @performer.reservations.by_date(@start_at)
    end

    def local_time(time)
      time.in_time_zone(@time_zone)
    end
  end
end
