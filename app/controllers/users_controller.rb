class UsersController < ApplicationController

	def show
  end

  def new	
		@user = User.new 
		render "users/new", :layout => 'front'
  end

	# 이건 필요가 없어 create에서 호출하면 되
	# email에서 클릭한 주소를 위한 액션은 있어야지
	def register_mailer
		@mail = RegisterMailer.sendmail_confirm().deliver
		render text: '메일로 전송된 링크를 클릭할 시, 회원가입이 완료됩니다.'
	end
  
	# https://coderwall.com/p/u56rra/ruby-on-rails-user-signup-email-confirmation-tutorial
	# http://www.sitepoint.com/rails-userpassword-authentication-from-scratch-part-i/
	def create
		@user = User.new(post_params)
		if @user.save
			render text: @user.name <<  "," << @user.email << "," << @user.password
			# 암호화 필요
		else 
			render "users/new", :layout => 'front'
		end
  end

  def edit
  end

  def update
  end

  def destroy
  end

private
	def post_params
		params.require(:user).permit(:email, :name, :password, :password_confirmation)
	end
end
