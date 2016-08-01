class UsersController < ApplicationController
	require 'digest/sha1'
	def show
  end

	def events
			@events = current_user.inverse_events
	end

	def search
		# /user/search
		respond_to do |format|
			if request.post? 
				type = search_params[:type]
				name = search_params[:name]
				if name.length == 0
					@users = []
				elsif type == "name"
					@users = User.where('name LIKE ?', "%#{name}%")	
				else 
					@users = User.where('nickname LIKE ?', "%#{name}%")	
				end
				format.js{ render :file => "users/search.js.erb" }
			else
				format.js { render :file => "users/search_form.js.erb" }
			end
		end
	end

  def new	
		@user = User.new 
		render "users/new", :layout => 'front'
  end

	# 이건 필요가 없어 create에서 호출하면 되
	# email에서 클릭한 주소를 위한 액션은 있어야지
	def auth_user 
		auth = EmailAuth.find_by(auth_key: params[:auth_key])
		if auth
			auth.user.my_auth = true
			auth.user.save
			auth.destroy
			flash[:notice]= '시스템 가동- 인증완료.-'
		else
			flash[:notice]= '없는 인증키 입니다.'
		end

		redirect_to '/login'
	end
  
	# https://coderwall.com/p/u56rra/ruby-on-rails-user-signup-email-confirmation-tutorial
	# http://www.sitepoint.com/rails-userpassword-authentication-from-scratch-part-i/
	def create
		@user = User.new(user_params)
		@user.use_photo = true 
		@user.salt = BCrypt::Engine.generate_salt
		@user.password = BCrypt::Engine.hash_secret(params[:user][:password], @user.salt)
		@user.password_confirmation = BCrypt::Engine.hash_secret(params[:user][:password_confirmation], @user.salt)
		if @user.save
			auth_key = @user.id.to_s + SecureRandom.urlsafe_base64.to_s 
			ea = EmailAuth.new(auth_key: auth_key, user_id: @user.id)
			ea.save
	 		RegisterMailer.sendmail_confirm(auth_key, @user).deliver

			flash[:notice]= "입력하신 메일 주소로 <br> 인증 메일이 발송되었습니다;D"
			redirect_to '/login'
		else 
			render "users/new", :layout => 'front'
		end
  end

  def edit
		@user = User.find(params[:id])
		if (current_user.id != @user.id) 
			if not (manager_list.include? current_user.id)
				redirect_to root_path 
			end
		end
  end

  def update
		@user= User.find(params[:id])
		if @user.user_type == 0 and params[:user][:password].length > 0 
			params[:user][:password] = BCrypt::Engine.hash_secret(params[:user][:password], @user.salt)
			params[:user][:password_confirmation] = BCrypt::Engine.hash_secret(params[:user][:password_confirmation], @user.salt)
		elsif 
			params[:user][:password] = @user.password 
			params[:user][:password_confirmation] = @user.password 
		end 

		if @user.update(user_params)
			redirect_to '/my_feeld' 
		else 
			render "users/edit"
		end
  end

  def destroy
  end

private
	def user_params
		params.require(:user).permit(:email, :name, :password, :password_confirmation, :user_type, :nickname, :use_nick, :company, :photo, :use_photo)
	end

	def search_params
		params.require(:search).permit(:type, :name)
	end
end
