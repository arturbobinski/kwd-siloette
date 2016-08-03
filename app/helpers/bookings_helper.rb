module BookingsHelper

  def time_slot_options(arry=(0..23))
    arry.map { |x| [slot_to_time(x), x] }
  end

  def slot_to_time(slot)
    time_format(Time.parse("#{slot % 24}:00"))
  end

  def time_format(time)
    time.strftime('%I:%M %p')
  end

  def date_format(date)
    I18n.l date, format: :long
  end

  def datetime_format(time)
    I18n.l time, format: :long
  end

  def local_time(time)
    time.in_time_zone(user_time_zone)
  end
end
