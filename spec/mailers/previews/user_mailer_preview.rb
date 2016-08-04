# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def service_invitation_email
    UserMailer.service_invitation_email User.last, Service.last
  end

  def user_verification_email
    UserMailer.user_verification_email User.last
  end

  def user_verified_mail
    UserMailer.user_verified_mail User.last
  end

  def new_booking_email
    UserMailer.new_booking_email Booking.last
  end

  def booking_accepted_email
    UserMailer.booking_accepted_email Booking.last
  end

  def booking_declined_email
    UserMailer.booking_declined_email Booking.last
  end

  def booking_canceled_email
    UserMailer.booking_canceled_email Booking.last
  end

  def booking_start_email_to_performer
    UserMailer.booking_start_email_to_performer Booking.last
  end

  def booking_start_email_to_user
    UserMailer.booking_start_email_to_user Booking.last
  end

  def payment_completed_email_to_user
    UserMailer.payment_completed_email_to_user Payment.last
  end

  def payment_completed_email_to_performer
    UserMailer.payment_completed_email_to_performer Payment.last
  end

  def payment_failed_email_to_user
    UserMailer.payment_failed_email_to_user Payment.last
  end

  def payment_failed_email_to_performer
    UserMailer.payment_failed_email_to_performer Payment.last
  end
end
