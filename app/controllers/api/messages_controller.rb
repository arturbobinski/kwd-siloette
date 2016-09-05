require 'twilio-ruby'

module Api
  class MessagesController < Api::BaseController

    def get_sms
      if verification_code = params[:Body][/\d{4}/]
        if booking = Booking.find_by(verification_code: verification_code)
          booking.verify! if booking.may_verify?
        end
      end

      render nothing: true
    end
  end
end