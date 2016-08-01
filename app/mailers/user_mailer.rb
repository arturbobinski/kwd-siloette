class UserMailer < ApplicationMailer

  add_template_helper(BookingsHelper)

  def service_invitation_email(invitee, service)
    @invitee, @service = invitee, service
    @user = @service.user

    mail(to: @invitee.email, subject: 'New invitaion!')
  end

  def new_booking_email(booking)
    @booking = booking
    @address = @booking.address
    @service = @booking.service
    @performer = @booking.performer

    mail(to: @performer.email, subject: 'You have new booking!')
  end

  def booking_accepted_email(booking)
    @booking = booking
    @service = @booking.service
    @user = @booking.user
    @performer = @booking.performer

    mail(to: @user.email, subject: 'Booking accepted!')
  end

  def booking_declined_email(booking)
    @booking = booking
    @service = @booking.service
    @user = @booking.user
    @performer = @booking.performer

    mail(to: @user.email, subject: 'Booking declined!')
  end

  def booking_canceled_email(booking)
    @booking = booking
    @service = @booking.service
    @user = @booking.user
    @performer = @booking.performer

    mail(to: @performer.email, subject: 'Booking cenceled!')
  end

  def payment_completed_email_to_user(payment)
    @payment = payment
    @booking = @payment.booking
    @service = @booking.service
    @source = @payment.source
    @user = @booking.user

    mail(to: @user.email, subject: 'Payment completed!')
  end

  def payment_completed_email_to_performer(payment)
    @payment = payment
    @booking = @payment.booking
    @service = @booking.service
    @performer = @booking.performer

    mail(to: @performer.email, subject: 'Payment completed!')
  end

  def payment_failed_email_to_user(payment)
    @payment = payment
    @booking = @payment.booking
    @service = @booking.service
    @source = @payment.source
    @user = @booking.user

    mail(to: @user.email, subject: 'Payment failed!')
  end

  def payment_failed_email_to_performer(payment)
    @payment = payment
    @booking = @payment.booking
    @service = @booking.service
    @performer = @booking.performer

    mail(to: @performer.email, subject: 'Payment failed!')
  end
end
