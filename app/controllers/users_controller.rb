class UsersController < ApplicationController
	require 'digest/sha1'
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
		@user.salt = BCrypt::Engine.generate_salt
		@user.password = BCrypt::Engine.hash_secret(params[:user][:password], @user.salt)
		@user.password_confirmation = BCrypt::Engine.hash_secret(params[:user][:password_confirmation], @user.salt)
		if @user.save
			flash[:notice]= "회원가입이 완료"
			redirect_to '/login'
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
		params.require(:user).permit(:email, :name, :password, :password_confirmation, :user_type)
	end
end
