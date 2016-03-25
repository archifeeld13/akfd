# Preview all emails at http://localhost:3000/rails/mailers/register_mailer
class RegisterMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/register_mailer/sendmail_confirm
  def sendmail_confirm
    RegisterMailer.sendmail_confirm
  end

end
