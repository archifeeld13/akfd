class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	skip_before_action :verify_authenticity_token, if: :json_request?


	before_action :set_fav_posts
	before_action :set_fav_tags

	# http://www.sitepoint.com/rails-authentication-oauth-2-0-omniauth/
	private
		def current_user
			@current_user ||= User.find_by(id: session[:user_id])
		end

		helper_method :current_user

		# 인기 마이필드 
		def set_fav_posts
			@fav_posts = Post.all 
			@fav_posts = @fav_posts.to_a
			@fav_posts.sort! {|x, y| y.likes.count <=> x.likes.count}
		end	

		def set_fav_tags
			@fav_tags = ActsAsTaggableOn::Tag.most_used(50)
		end
	protected
		def json_request?
			request.format.json?
		end
end
