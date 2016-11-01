class PlikesController < ApplicationController
	before_action :check_logined, only: [:create]

  def create
		plike = Plike.find_by(user_id: current_user.id, project_id: params[:project_id])

		if plike
			plike.destroy
		else
			plike =  Plike.new(user_id: current_user.id, project_id: params[:project_id])
			plike.save

			# 이벤트 메시지 보내기
			"""
			if current_user.id != plike.project.user.id
				e = Event.new
				e.user_id = current_user.id
				e.target_id = plike.project.user.id
				e.event_type = 2 # ??????  
				e.post_id = plike.post.id
				e.check = false
				e.save
			end
			"""
		end
		@project = Project.find(params[:project_id]) 
	end
end
