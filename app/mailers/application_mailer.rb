class ApplicationMailer < ActionMailer::Base

  default from: Figaro.env.default_admin_email
  layout 'mailer'
end
