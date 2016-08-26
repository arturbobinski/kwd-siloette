class BookingDecorator < Draper::Decorator
  delegate_all

  def start_at_for_performer
    I18n.l start_at.in_time_zone(performer.time_zone), format: :long
  end

  def start_at_for_customer
    I18n.l start_at.in_time_zone(user.time_zone), format: :long
  end

 def end_at_for_performer
    I18n.l end_at.in_time_zone(performer.time_zone), format: :long
  end

  def end_at_for_customer
    I18n.l end_at.in_time_zone(user.time_zone), format: :long
  end

  def start_date_for_performer
    I18n.l start_at.in_time_zone(performer.time_zone).to_date, format: :long
  end

  def start_date_for_customer
    I18n.l start_at.in_time_zone(user.time_zone).to_date, format: :long
  end

  def start_time_for_performer
    start_at.in_time_zone(performer.time_zone).strftime('%l:%M %p')
  end

  def start_time_for_customer
    start_at.in_time_zone(user.time_zone).strftime('%l:%M %p')
  end
end