class WelcomeController < ApplicationController
  def index
		@posts = Post.all
		@users = User.all
  end

	def login
		render "welcome/login", :layout => 'front' 
	end

	def test
		posts = Post.all
		posts.each do |p|
			if p.images.size > 0
				p.post_type = 1
			else 
				p.post_type = 0
			end
			p.save
		end
		render text: "성공;D"
	end
end
