class WelcomeController < ApplicationController
  def index
		@posts = Post.all
		@users = User.all
  end

	def test
		shares = Share.all
		shares.each do |s|
			s.destroy	
		end
		redirect_to root_path
	end
end
