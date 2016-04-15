class LikesController < ApplicationController
	before_action :check_logined, only: [:create]

  def create
=begin
		like = Like.find_or_create_by(user_id: current_user.id, post_id: params[:post_id])
=end
		like = Like.find_by(user_id: current_user.id, post_id: params[:post_id])
		if like
			like.destroy
		else
			like =  Like.new(user_id: current_user.id, post_id: params[:post_id])
			like.save

			if current_user.id != like.post.user.id
				e = Event.new
				e.user_id = current_user.id
				e.target_id = like.post.user.id
				e.event_type = 2 
				e.post_id = like.post.id
				e.check = false
				e.save
			end
		end
		@post = Post.find(params[:post_id]) 

	end
end
