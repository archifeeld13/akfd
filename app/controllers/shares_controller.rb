class SharesController < ApplicationController
  def create
		share = Share.find_by(user_id: current_user.id, post_id: params[:post_id])
		if share
			flash[:notice] = "필드인(공유) 취소! 마이필드 공유목록에서 제외 되었습니다."
			share.destroy
		else
			share =  Share.new(user_id: current_user.id, post_id: params[:post_id])
			flash[:notice] = "필드인(공유) 완료! 마이필드에서 확인해 주세요^^"
			share.save
		end
		@post = Post.find(params[:post_id])
	end
end
