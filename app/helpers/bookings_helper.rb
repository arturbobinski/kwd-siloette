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

  def extend_time_options(slots)
    options = []
    prev = slots.first
    slots.each_with_index do |x, i|
      hours = i + 1
      if x > prev + 1
        break
      end
      options << ["#{slot_to_time(x + 1)}(#{t('common.hours', count: hours)})", hours]
      prev = x
    end
    options
  end
end
