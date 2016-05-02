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

=begin
	u = User.find(106)
	u.password = BCrypt::Engine.hash_secret("5252", u.salt)
	u.password_confirmation = BCrypt::Engine.hash_secret("5252", u.salt)
	u.save
=end

=begin
	u = User.all
	u.each do |user|
		user.my_auth = true
		user.save
	end
=end

=begin
	# 친구 삭제
	result = []
	u = User.all
	u.each do |user|
		if not Friendship.find_by(user_id: user.id, friend_id: 48) 
			result << user.id
			@friendship = user.friendships.new(:friend_id => 48)
			@friendship.save
		end
	end

	render text: result.to_s
=end
	results = []
	User.all.each do |u|
		if u.company == "아키필드 에디터" or u.company == "아키필드에디터"
			results << u.id
		end
	end
	render text: results.to_s	
	end

	def state
			render text: "현재 가입자: " +  User.all.count.to_s
	end

end
