class WelcomeController < ApplicationController
  def index
		@posts = Post.all
		@users = User.all
  end

	def test
		friendships = Friendship.all
		friendships.each do |f|
			f.destroy
		end

		redirect_to root_path
	end
end
