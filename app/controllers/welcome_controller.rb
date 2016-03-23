class WelcomeController < ApplicationController
  def index
		@posts = Post.all
		@users = User.all
  end

	def login
		render "welcome/login", :layout => false
	end

	def register
		render "welcome/register", :layout => false
	end

	def test
		shares = Share.all
		shares.each do |s|
			s.destroy	
		end
		redirect_to root_path
	end
end
