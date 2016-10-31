class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	#before_action :notice

	before_action :set_fav_posts
	before_action :set_fav_tags
	before_action :set_fav_users

	# http://www.sitepoint.com/rails-authentication-oauth-2-0-omniauth/
	private
		def current_user
			@current_user ||= User.find_by(id: session[:user_id])
		end
		helper_method :current_user


		def notice
			redirect_to notice_path
		end

		# 추천 필드업 
		def set_fav_posts
			@fav_posts = Post.where(is_secret: false).where("created_at > ?", 1.week.ago.to_date) 
			@fav_posts = @fav_posts.to_a
			@fav_posts.sort! {|x, y| (y.likes.count * 100 + y.view_count) <=> (x.likes.count * 100 + x.view_count)}
			#@fav_posts.sort! {|x, y| y.likes.count <=> x.likes.count }
		end	

		def set_fav_tags
			@fav_tags = ActsAsTaggableOn::Tag.most_used(50)
		end


		def set_fav_users
			@fav_users = []
			fav_user= [117 ,119, 171, 228, 247, 253, 305, 782, 794, 831, 850, 1159, 1273]
			fav_user.each do |u|
				@fav_users << User.find(u)
			end
		end	

	protected
		def json_request?
			request.format.json?
		end

		def check_logined
			if !session[:user_id] 
				flash[:notice] = "로그인이 필요한 서비스입니다;D"
				redirect_to login_path	
			end
		end

		def manager_list
			[1, 4, 48]
		end
		helper_method :manager_list
end
