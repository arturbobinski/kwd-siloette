module BookingsHelper

  def time_slot_options(arry=(0..23))
    arry.map { |x| [slot_to_time(x), x] }
  end

  def slot_to_time(slot)
    time_format(Time.parse("#{slot}:00"))
  end

  def time_format(time)
    time.strftime('%I:%M %p')
  end

  def date_format(time)
    time.strftime('%a, %e %b %Y')
  end

  def datetime_format(time)
    time.strftime('%a, %e %b %I:%M %p')
  end
end
