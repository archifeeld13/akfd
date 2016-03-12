class SharesController < ApplicationController
  def create
		share = Share.find_by(user_id: current_user.id, post_id: params[:post_id])
		if share
			share.destroy
		else
			share =  Share.new(user_id: current_user.id, post_id: params[:post_id])
			share.save
		end
		@post = Post.find(params[:post_id])
	end
end
