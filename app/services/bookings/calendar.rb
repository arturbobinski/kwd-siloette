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
          start_at = local_time(booking.start_at)
          start_slot = start_at.to_date < @start_at_in_zone.to_date ? 0 : start_at.hour
          end_at = local_time(booking.end_at)
          end_slot = end_at.to_date > @start_at_in_zone.to_date ? 24 : end_at.hour
          slots += (start_slot..end_slot - 1).to_a
        end
        slots += reservations.map { |x| local_time(x.start_at).hour }

        if @start_at_in_zone.to_date == @time_zone.today
          slots += (0..@start_at_in_zone.hour).to_a
        end

        schedule_end_slot = schedule.end_slot > 23 ? 23 : schedule.end_slot
        (schedule.start_slot..schedule_end_slot).to_a - slots.uniq
      else
        []
      end
    end

    def bookings
      @bookings ||= @performer.received_bookings.where.not(state: %w(completed canceled declined)).by_date(@start_at)
    end

    def reservations
      @reservations ||= @performer.reservations.by_date(@start_at)
    end

    def local_time(time)
      time.in_time_zone(@time_zone)
    end
  end
end
