class FriendshipsController < ApplicationController
	before_action :check_logined, only: [:create,  :destroy]

	def create
		@friendship = current_user.friendships.find_or_create_by(:friend_id => params[:friend_id])
		
		if params[:friend_id] != current_user.id and @friendship.save
			#flash[:notice] = "Added friend."
			e = Event.new
			e.user_id = current_user.id
			e.target_id = params[:friend_id] 
			e.event_type = 0 
			e.check = false
			e.save

			redirect_to("/my_feeld?user_id=#{params[:friend_id]}")
		else
			#flash[:error] = "Unable to add friend."
			redirect_to(:back)
		end
	end

	def show
		show_type = params[:type]
		@user = User.find(params[:id])
		
		respond_to do |format|
			#format.html { render :action => "new" }
			case show_type 
				when 'follow' then format.js { render :file => "friendships/follow.js.erb" }
				when 'follower' then format.js { render :file => "friendships/follower.js.erb" }
			end
		end
	end

	def destroy
		@friendship = current_user.friendships.find(params[:id])
		@friendship.destroy
		flash[:notice] = "Removed friendship."
		redirect_to(:back)
	end
end
