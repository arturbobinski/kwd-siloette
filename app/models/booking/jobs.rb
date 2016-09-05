module Booking::Jobs
  extend ActiveSupport::Concern

  included do

    def notify
      case current_state
      when :pending
        UserMailer.new_booking_email(self).deliver_later
        msg = "#{address.full_name} wants you to be a #{service.title} for a #{event_type.name} " \
              "at #{decorate.start_time_for_performer} on #{decorate.start_date_for_performer}. " \
              "You’ll make $#{amount}. Login to accept"
        TwilioService.new.send_sms(performer.full_phone_number, msg)
      when :accepted
        UserMailer.booking_accepted_email(self).deliver_later
        msg = "Great news! #{performer.perform_name} accepted your booking request. " \
              "Get excited, she’ll see you at #{decorate.start_time_for_customer} on " \
              "#{decorate.start_date_for_customer}.\n" \
              "Love the Siloette Team xo"
        TwilioService.new.send_sms(address.full_phone_number, msg)
        Booking.delay(run_at: (start_at - 1.hour)).perform_async(id, :remind_start)
      when :verified
        UserMailer.booking_verified_email(self).deliver_later
        msg = "Your booking was successfully verified and you will receive payment in 36 hours."
        TwilioService.new.send_sms(performer.full_phone_number, msg)
        Booking.delay(run_at: (end_at + 24.hour)).perform_async(id, :complete)
      when :completed
        UserMailer.booking_completed_email(self).deliver_later
        msg = "Your booking for #{service.title} was completed. " \
              "Please call on #{Figaro.env.twillio_admin_number} and use this code " \
              "#{verification_code} to give feedback about #{performer.perform_name}."
        TwilioService.new.send_sms(performer.full_phone_number, msg)
      when :declined
        UserMailer.booking_declined_email(self).deliver_later
        msg = "Unfortunately #{performer.perform_name} isn’t available for your booking. " \
              "Visit siloette.co to see other options and book someone else."
        TwilioService.new.send_sms(address.full_phone_number, msg)
      when :canceled
        if aasm.from_state == :pending
          UserMailer.booking_canceled_email(self).deliver_later
          msg = "Unfortunately, #{address.full_name} canceled their #{service.title} booking. " \
                "We’ll keep you posted if they reschedule."
          TwilioService.new.send_sms(performer.full_phone_number, msg)
        end
      end
    end

    def remind_start
      return unless paid?
      UserMailer.booking_start_email_to_performer(self).deliver_later
      msg = "Your booking with #{address.first_name} starts in an hour. " \
            "The #{service.title} is located at #{address.full_address}. " \
            "Don’t forget your Wearsafe wearable!"
      TwilioService.new.send_sms(performer.full_phone_number, msg)
      UserMailer.booking_start_email_to_user(self).deliver_later
      msg = "You have a new booking started in an hour\n" \
            "It’s almost showtime. #{performer.perform_name} will arrive in one hour."
      TwilioService.new.send_sms(address.full_phone_number, msg)
    end
  end
end