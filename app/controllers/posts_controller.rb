class PostsController < ApplicationController
  def index
  end

	def create
		"""
			ajax, ..
		"""
		@post = Post.new(params.require(:post).permit(:title, :content))
		@post.save
		redirect_to @index
	end
end
