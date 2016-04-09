class CommentsController < ApplicationController
	before_action :set_post
	before_action :set_comment, only: :destroy
	before_action :check_logined, only: [:create, :destroy]

  def create
		@comment = @post.comments.new(comment_params)
		@comment.user_id = current_user.id
		@comment.save

		e = Event.new
		e.user_id = current_user.id
		e.target_id = @post.user.id
		e.event_type = 1
		e.post_id = @post.id
		e.check = false
		e.save
  end

  def destroy
		@comment.destroy
  end

private
	def set_post
		@post = Post.find(params[:post_id])
	end

	def set_comment
		@comment = @post.comments.find(params[:id])
	end

	def comment_params
		params.require(:comment).permit(:body)
	end
end
