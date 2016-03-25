class RegisterMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.register_mailer.sendmail_confirm.subject
  #
	
	default from: 'welcome@archifeeld.com'
  def sendmail_confirm
    @greeting = 'www.naver.com'

    mail to: "0911jiwon@naver.com",
			subject: '메롱'
  end
end
