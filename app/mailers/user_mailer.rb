class UserMailer < ApplicationMailer

  add_template_helper(BookingsHelper)

  def service_invitation_email(invitee, service)
    @invitee, @service = invitee, service
    @user = @service.user

    mail(to: @invitee.email, subject: 'New invitaion!')
  end

  def user_verification_email(user)
    @user = user

    mail(to: 'admin@strpprs.com', subject: 'New user verification required!')
  end

  def user_verified_mail(user)
    @user = user

    mail(to: @user.email, subject: 'Account verified!')
  end

  def new_booking_email(booking)
    @booking = booking
    load_booking_resoruces

    mail(to: @performer.email, subject: 'You have new booking!')
  end

  def booking_accepted_email(booking)
    @booking = booking
    load_booking_resoruces

    mail(to: @user.email, subject: 'Booking accepted!')
  end

  def booking_declined_email(booking)
    @booking = booking
    load_booking_resoruces

    mail(to: @user.email, subject: 'Booking declined!')
  end

  def booking_canceled_email(booking)
    @booking = booking
    load_booking_resoruces

    mail(to: @performer.email, subject: 'Booking cenceled!')
  end

  def booking_start_email_to_performer(booking)
    @booking = booking
    load_booking_resoruces

    mail(to: @performer.email, subject: 'Service start soon!')
  end

  def booking_start_email_to_user(booking)
    @booking = booking
    load_booking_resoruces

    mail(to: @user.email, subject: 'Service start soon!')
  end

  def payment_completed_email_to_user(payment)
    @payment = payment
    load_payment_resoruces

    mail(to: @user.email, subject: 'Payment completed!')
  end

  def payment_completed_email_to_performer(payment)
    @payment = payment
    load_payment_resoruces

    mail(to: @performer.email, subject: 'Payment completed!')
  end

  def payment_failed_email_to_user(payment)
    @payment = payment
    load_payment_resoruces

    mail(to: @user.email, subject: 'Payment failed!')
  end

  def payment_failed_email_to_performer(payment)
    @payment = payment
    load_payment_resoruces

    mail(to: @performer.email, subject: 'Payment failed!')
  end

  private

  def load_booking_resoruces
    @service = @booking.service
    @user = @booking.user
    @performer = @booking.performer
  end

  def load_payment_resoruces
    @payable = @payment.payable
    @service = @payable.service
    @source = @payment.source
    @user = @payable.user
    @performer = @payable.performer
  end
end
