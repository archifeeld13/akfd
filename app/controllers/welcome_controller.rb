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
	u = User.find(1159)
	u.password = BCrypt::Engine.hash_secret("5252", u.salt)
	u.password_confirmation = BCrypt::Engine.hash_secret("5252", u.salt)
	u.save
	render text:"good"
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
=begin
	results = []
	User.all.each do |u|
		if u.company == "아키필드 에디터" or u.company == "아키필드에디터"
			results << u.id
		end
	end
	render text: results.to_s	
=end
=begin
	# image reprocess
	u = User.find(1)
	u.photo.recreate_versions!
	u.photo.cache_stored_file! 
	u.photo.retrieve_from_cache!(u.photo.cache_name) 
	u.save!
	render text: "good"
=end
	# image reprocess
	#p = Photo.find(628)
=begin	
	# 이미지 타입 교체 
	Photo.all.each do |p|
		if p.id > 445 and not (p.image.to_s.downcase.include? "gif")
			p.image.recreate_versions!
			p.image.cache_stored_file! 
			p.image.retrieve_from_cache!(p.image.cache_name) 
			p.save!
		end
	end
	render text: "ok"
=end
=begin	
		p = Photo.find(685)
			p.image.recreate_versions!
			p.image.cache_stored_file! 
			p.image.retrieve_from_cache!(p.image.cache_name) 
			p.save!
			render text: "ok"
=end

=begin	
		u = User.find(375)
		u.update(name: "김건전")
		render text: u.name
=end

=begin 연구용
	tags = []
	#len = 0 
	ret = ""
	fl = [] 
	users = User.all
	users.each do |user|
		ret += (user.friendships.count + user.inverse_friends.count).to_s  + "<br>"
	end
	ret += "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@<br>"

	posts = Post.all
	posts.each do |p|
		tags.append(p.tag_list)
		if p.tag_list.length > 0
			ret += p.tag_list.to_s + "<br>"
		end
		#len += p.tag_list.length
	end

	#render text: posts.length.to_s + "/" + len.to_s + " " + tags.to_s 
	render text: ret 
=end
	ret = ""
	users = User.all
	
	users.each do |u|
		s = 0	
		c = 0
		l = 0
		v = 0
		u.posts.each do |p|
			s += p.shares.count
			c += p.comments.count
			l += p.likes.count
			v += p.view_count
		end
		if s + c + l + v > 0
			#ret += s.to_s + "/"+ c.to_s + "/" + l.to_s + "/" + v.to_s +  "<br/>"
			ret += (s + c + l + v ).to_s + "</br>"
		end
	end

	render text: ret

	end

	def state
			render text: "현재 가입자: " +  User.all.count.to_s
	end

end
