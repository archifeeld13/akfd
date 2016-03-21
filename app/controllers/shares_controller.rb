class SharesController < ApplicationController
  def create
		share = Share.find_by(user_id: current_user.id, post_id: params[:post_id])
		if share
			flash[:notice] = "필드인(공유) 취소"
			share.destroy
		else
			share =  Share.new(user_id: current_user.id, post_id: params[:post_id])
			flash[:notice] = "필드인(공유) 완료"
			share.save
		end
		@post = Post.find(params[:post_id])
	end
end
