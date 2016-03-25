class UsersController < ApplicationController
	def show
  end

  def new	
		@user = User.new 
		render "users/new", :layout => false
  end

	def register_mailer
		@mail = RegisterMailer.sendmail_confirm().deliver
		render text: '메일로 전송된 링크를 클릭할 시, 회원가입이 완료됩니다.'
	end
  
	def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

	def post_params
		params.require(:user).permit(:email, :name, :password, :password_confirmation)
	end
end
