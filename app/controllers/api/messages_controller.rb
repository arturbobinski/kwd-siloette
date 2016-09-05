require 'twilio-ruby'
require 'sanitize'

module Api
  class MessagesController < Api::BaseController

    def get_sms
      phone_number = Sanitize.clean(params[:From])
      profile = Profile.by_phone_number(phone_number).first

      if profile && verification_code = params[:Body][/\d{4}/]
        if booking = profile.user.received_bookings.find_by(verification_code: verification_code)
          booking.verify! if booking.may_verify?
        end
      end

      render nothing: true
    end
  end
end