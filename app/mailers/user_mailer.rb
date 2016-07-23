class UserMailer < ApplicationMailer

  def service_invitation_email(invitee, service)
    @invitee, @service = invitee, service
    @user = @service.user

    mail(to: @invitee.email, subject: 'New invitaion!')
  end
end
