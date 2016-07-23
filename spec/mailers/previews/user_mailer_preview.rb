# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def service_invitation_email
    UserMailer.service_invitation_email User.last, Service.last
  end
end
