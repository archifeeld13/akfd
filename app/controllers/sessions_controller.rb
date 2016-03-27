class SessionsController < ApplicationController
	def new
		render "sessions/new", :layout => 'front' 
	end

	def create_facebook
		begin
			@user = User.from_omniauth(request.env['omniauth.auth'])
			session[:user_id] = @user.id
			flash[:success] = "Welcome, #{@user.name}!"
		rescue
			flash[:warning] = "There was an error while trying to authenticate you..."
		end
		redirect_to posts_path 
		#render text: request.env['omniauth.auth'].to_json
	end


	def create_normal
		user = User.find_by(email: params[:session][:email])
		if user 
			#salt = BCrypt::Engine.generate_salt
			#pw = BCrypt::Engine.hash_secret(params[:session][:password], salt)
			pw = params[:session][:password]
			if user.password == pw 
				session[:user_id] = user.id					
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
			flash[:success] = 'See you!'
		end
		redirect_to root_path
	end

private
	def post_params
		params.require(:session).permit(:email, :password)
	end
end
