class WelcomeController < ApplicationController
  def index
		@posts = Post.all
		@users = User.all
  end


	def test
=begin 포스트 타입 설정
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

=begin 유저타입에 대한 사진 사용 여부
		users = User.all
		users.each do |u|
			if u.user_type == 0

				u.use_photo = true
				u.save
			end
		end
=end

=begin 이메일 인증
		users = User.all
		users.each do |u|
			u.email_auth = true
			u.save
		end
		render text: 'ok'
=end
		u = User.find(106)
		u.password = BCrypt::Engine.hash_secret("1111", u.salt)
		u.password_confirmation = BCrypt::Engine.hash_secret("1111", u.salt)
		u.save
		render text: "success"
	end

	def state
			render text: "현재 가입자: " +  User.all.count.to_s
	end

end
