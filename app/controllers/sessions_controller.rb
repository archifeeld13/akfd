class SessionsController < ApplicationController
	require 'digest/sha1'
	def new
		if current_user
			redirect_to posts_path
		else 
			render "sessions/new", :layout => 'front' 
		end
	end

	def create_facebook
		begin
			@user = User.from_omniauth(request.env['omniauth.auth'])
			@user.user_type = 1
			@user.save
			session[:user_id] = @user.id
			# 아키필드 계정 친구로 추가
			@friendship = @user.friendships.find_or_create_by(:friend_id => 48)
			@friendship.save
			# ######
			flash[:success] = "Welcome, #{@user.name}!"
		rescue
			flash[:warning] = "There was an error while trying to authenticate you..."
		end
		redirect_to posts_path 
		#render text: request.env['omniauth.auth'].to_json
	end


	def create_normal
		@user = User.find_by(email: params[:session][:email])
		if not @user.my_auth
			flash[:notice] = "입력한 이메일 주소로 발송된<br /> 인증 메일을 확인해 주세요"
			redirect_to :back
		elsif @user 
			pw = BCrypt::Engine.hash_secret(params[:session][:password], @user.salt)
			if @user.password == pw 
				session[:user_id] = @user.id					
				# 아키필드 계정 친구로 추가
				@friendship = @user.friendships.find_or_create_by(:friend_id => 48)
				@friendship.save
				# ######
				redirect_to posts_path 
			else
				flash[:notice] = "이메일 혹은 비밀번호가 잘못되었습니다"
				redirect_to :back		
			end
		else 
			flash[:notice] = "이메일 혹은 비밀번호가 잘못되었습니다"
			redirect_to :back		
		end
	end

	def destroy
		if current_user
			session.delete(:user_id)
			flash[:notice] = '이용해주셔서 감사합니다;D'
		end
		redirect_to root_path
	end

private
	def post_params
		params.require(:session).permit(:email, :password)
	end
end
