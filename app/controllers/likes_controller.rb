class LikesController < ApplicationController
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
		end
		@post = Post.find(params[:post_id])
	end
end
