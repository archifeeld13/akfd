class FriendshipsController < ApplicationController
	def create
		@friendship = current_user.friendships.build(:friend_id => params[:friend_id])
		if @friendship.save
			flash[:notice] = "Added friend."
			redirect_to(:back)
		else
			flash[:error] = "Unable to add friend."
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
