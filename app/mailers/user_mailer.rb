class UserMailer < ApplicationMailer

  add_template_helper(BookingsHelper)

  def service_invitation_email(invitee, service)
    @invitee, @service = invitee, service
    @user = @service.user

    mail(to: @invitee.email, subject: 'New invitaion!')
  end

  def user_verifying_email(user)
    @user = user

    mail(to: @user.email, subject: 'Account is being verified!')
  end

  def user_verification_email(user)
    @user = user

    mail(to: 'rs@siloette.co', subject: 'New user verification required!')
  end

  def user_verified_mail(user)
    @user = user

    mail(to: @user.email, subject: 'Account verified!')
  end
  
  def send_welcome_mail(user)
    @user = user

    mail(to: @user.email, subject: 'Welcome!')
  end
  
  def send_profile_approved(user)
    @user = user

    mail(to: @user.email, subject: 'Profile Approved!')
  end

  def new_booking_email(booking)
    @booking = booking
    load_booking_resoruces

    mail(to: @performer.email, subject: 'You have new booking!')
  end

  def booking_accepted_email(booking)
    @booking = booking
    load_booking_resoruces
    @terms_page = Page.find_by(slug: 'terms-of-use')

    mail(to: @user.email, subject: 'Booking accepted!')
  end

  def booking_verified_email(booking)
    @booking = booking
    load_booking_resoruces

    mail(to: @performer.email, subject: 'Booking verified!')
  end

  def booking_declined_email(booking)
    @booking = booking
    load_booking_resoruces
    @services = Service.active.open.where(category_id: @service.category_id).where.not(id: @service.id).limit(4)

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

  def booking_completed_email(booking)
    @booking = booking
    load_booking_resoruces

    mail(to: @user.email, subject: 'Booking completed!')
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
    @address = @booking.address
    @user = @booking.user
    @performer = @booking.performer
  end

  def load_payment_resoruces
    @payable = @payment.payable
    @source = @payment.source
    if @payable.is_a?(Booking)
      @service = @payable.service
      @user = @payable.user
      @performer = @payable.performer
    elsif @payable.is_a?(BookingExtension)
      @booking = @payable.booking
      @service = @booking.service
      @user = @booking.user
      @performer = @booking.performer
    end
  end
end
