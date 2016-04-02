class RegisterMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.register_mailer.sendmail_confirm.subject
  #
  def sendmail_confirm(auth_key, user)
    @auth_link = 'http://archifeeld.net:3000/auth_user/' + auth_key
		
    mail to: user.email,
			subject: 'Archifeeld 회원가입 인증 메일'
  end
end
