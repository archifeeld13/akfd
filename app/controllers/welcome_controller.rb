class WelcomeController < ApplicationController
  def index
		@posts = Post.all
		@users = User.all
  end


	def test
=begin
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
		users = User.all
		users.each do |u|
			if u.email
				u.user_type = 0
			else
				u.user_type = 1
			end
			u.save
		end
=end
		users = User.all
		users.each do |u|
			if u.user_type == 0

				u.use_photo = true
				u.save
			end
		end
		render text: 'ok'
	end

	def state
			render text: "현재 가입자: " +  User.all.count.to_s
	end

end
