class PostsController < ApplicationController
	require 'json'
	before_action :check_logined, only: [:new, :timeline, :message_box, :create, :edit, :update, :destroy]

  def index
		if params[:tag]
		# 태그 검색
			@posts = Post.tagged_with(params[:tag]).reverse
			flash[:notice] = "<strong class='text-danger'>#{params[:tag]}</strong> 에 대한 검색결과 입니다."
		elsif params[:type]
		# 필터링
			if params[:type] == "txt"
				@selected = "txt"
				post_type = 0
				flash[:notice] = "<strong class='text-danger'>텍스트</strong> 필터링 결과 입니다."
			elsif params[:type] == "img"
				@selected = "img"
				post_type = 1
				flash[:notice] = "<strong class='text-danger'>이미지</strong> 필터링 결과 입니다."
			else
				# link..
			end
			@posts = Post.where(post_type: post_type, is_secret: false).reverse
		else
		# 기본 메인 페이지
			if params[:page]
				# js???	
				page = params[:page].to_i
				@posts = Post.where(is_secret: false).reverse[(page * 20)..(page * 20) + 19]
			else
				@selected = "posts"
				@posts = Post.where(is_secret: false).reverse[0..19]
			end
			flash[:notice] = "전체 필드업을 최근 작성순으로 보여줍니다 :D"
		end
  end

	def timeline 
		@selected = "timeline"
		@posts = []
		current_user.friendships.each do |f| 
			f.friend.posts.each do |p|
				if not p.is_secret 
					@posts << p
				end
			end
		end

		current_user.posts.each do |p|
			@posts << p
		end

		# 미래에는 메모리에 안올라오는 날이 있을 듯?
		@posts = @posts.sort_by{|p| p.created_at}.reverse
		flash[:notice] = "친구들의 필드업을 보여줍니다;D"

		if params[:page]
			# js	
			page = params[:page].to_i
			@posts = @posts[(page * 20)..(page * 20) + 19]
		else
			@posts = @posts[0..19]
		end
	end

	def college
		@selected = "college"
		clist = [117 ,119, 171, 228, 247, 253, 305, 782, 794, 831, 850, 1159, 1273]
		@posts = []
		Post.all.reverse.each do |p|
			if clist.include? p.user.id 
				@posts << p	
			end
		end
		flash[:notice] = "각 대학교의 필드업을 보여줍니다;D"
		render "index"	
	end

	def editor 
		@selected = "editor"
		elist = [69, 134, 137, 140, 141, 146, 156, 161, 165, 218] 
		@posts = []
		Post.all.reverse.each do |p|
			if elist.include? p.user.id and not p.is_secret 
				@posts << p	
			end
		end
		flash[:notice] = "아키필드 에디터단의 필드업을 보여줍니다;D"
		render "index"	
	end

=begin
	my_feeld 에 속하는 기능들
		- message_box
		- archive_mine
		- archive_share
		- project_management
=end
	def my_feeld
	"""
		# 회원 이름을 클릭해서 들어오면 /my_feeld?user_id=유저아이디
		# 형식으로 날라온다
		if params[:user_id] and (!current_user or (User.find(params[:user_id]).id != current_user.id))
			@isMine = false
			@user = User.find(params[:user_id])
			@projects = Project.where(user_id: User.find(params[:user_id]).id).reverse
		# 내 페이지 일 때
		# 마이필드 버튼을 클릭해서 /my_feeld로 접속했을 때 실행되는 부분 
		# login_check를 쓰지않고 직접 체크해야 하는 상황
		elsif session[:user_id] 
			@isMine = true 
			@user = User.find(current_user.id)
			@projects = Project.where(user_id: current_user.id).reverse
		else
			redirect_to login_path
		end
	"""
		# 다른 사람 페이지 볼 때, 비밀글 보이면 안돼
		if params[:user_id]
			@user = User.find(params[:user_id])
			@posts = Post.where(user_id: User.find(params[:user_id]).id, is_secret: false).reverse
			flash[:notice] = "#{@user.name}의 마이필드입니다 ;D"
		else
			@user = User.find(current_user.id)
			@posts = Post.where(user_id: current_user.id).reverse
			flash[:notice] = "나의 작품을 관리합니다;D"
		end
	end

	def message_box
		# 나중에 메시지 보내는 용도로 쓸 것임
	end

	#
	# archive_mine, archive_share, project_management-> ajax
	# in my_feeld
	# 
	def archive_mine
		# 다른 사람 페이지 볼 때, 비밀글 보이면 안돼
		if params[:user_id]
			@posts = Post.where(user_id: User.find(params[:user_id]).id, is_secret: false).reverse
		else
			@posts = Post.where(user_id: current_user.id).reverse
		end
	end

	def archive_share
		if params[:user_id]
			@posts = User.find(params[:user_id]).shared_posts.reverse
		else
			@posts = User.find(current_user.id).shared_posts.reverse
		end
	end

	def project_management
		# 내 페이지가 아닐 때, 현재 유저가 없거나 혹은 로긴하고 있는 유저의 페이지가 아닐 때
		if params[:user_id] 
		#if params[:user_id] and (!current_user or (User.find(params[:user_id]).id != current_user.id))
			@isMine = false
			@projects = Project.where(user_id: User.find(params[:user_id]).id).reverse
		# 내 페이지 일 때
		else
			@isMine = true 
			@projects = Project.where(user_id: current_user.id).reverse
		end
	end

	# 특정 프로젝트를 눌렀을 때의 행동
	def project_list_in
		project = Project.find(params[:project_id])
		@posts = project.posts.reverse
		@projects = [project] 
		# 1개짜리 배열, projects/_project.html.erb 재활용위해..
		# 그 안에서 @projects에 대해 each문 돌림
	end
=begin	
	 in my_feeld
	 end 
=end

	def show
		flash[:notice] = "아키필드에 오신걸 환영합니다 ;D"
		# 혹시 events목록에 이 글이 있다면
		# 해당 이벤트를 check true로 만든다
		if current_user
			my_events = Event.where(post_id: params[:id], target_id: current_user.id)		
			my_events.each do |e|
				e.check = true
				e.save
			end
		end
		@post = Post.find(params[:id])
		@post.view_count += 1
		@post.save
		@comment = Comment.new # 이거 안적으니까 지난 시간 구하는거에서 에러나

		# 비슷한 글 추천
		@posts = []
		@post.tag_list.to_a.each do |tag|
			@posts << Post.tagged_with(tag).shuffle[0..5]
		end
		# 쭉 펴기
		@posts = @posts.flatten.delete_if{|p| p.id == @post.id or p.is_secret == true}.shuffle[0..9]

		@isReco = false 
		if @posts.length > 0
			@isReco = true
		else
			@posts = Post.where(is_secret:false).reverse[0..30].shuffle[0..9]
		end

		# secret false 제외 시켜야됌
		#@posts = Post.where(post_type: post_type, is_secret: false).reverse

		respond_to do |format|
			format.html { render :action => "show" }
			format.js { render :file => "posts/show.js.erb" }
		end
	end

	"""
		업로드 기능 시작
		업로드 기능 시작
		업로드 기능 시작
	"""
  def new
		@post = Post.new
		respond_to do |format|
			if params[:type] == "link"
				format.js { render :file => "posts/link_new.js.erb" }
			else
				# 링크업 페이지는 따로 만들거임
				@isNew = true
				format.html { render :action => "new" }
			end
		end
  end

	def edit
		@post = Post.find(params[:id])	
	end

	def link_create
		# linkinput을 했을 때 오는곳 (따로 컨트롤러 만들지 않았다)
		@link = params[:link]
		@object = LinkThumbnailer.generate(params[:link])
		@post = Post.new
	end

	def create
		# 
		# post_type // 0:text, 1:img, 2:link
		#
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		@post.save

		# 이미지 타입 : 이미지 저장
		if @post.post_type == 1 
			if params[:images]
				params[:images].each do |image|
					#image.original_filename 
					@post.photos.create(image: image)
				end
			end
		end


		if @post.post_type == 2
			link = Link.new
			link.link_url = params[:link_url]
			link.link_title= params[:link_title]
			link.image_url = params[:image_url]
			link.post_id = @post.id
			link.save
		end

		# show 로 전환될 경우 필요
		@comment = Comment.new 

		if @post.post_type == 1
			# 이미지 타입의 경우 수정으로 리다이렉트
			render "edit"
		else 
			redirect_to @post
		end
	end

	def update
		# 현재는 링크업 수정 안됨
		@post = Post.find(params[:id])
		
		# post_type이 실제로 1일 때만 해줘야지
		# 0에서 1로 바뀌려는 찰나에 여기에 걸려버리면 안됌(강제로 바꿔놓은 1이 다시 0으로 바뀜)
		if params[:post][:post_type] == "1" and @post.post_type == 1
			# photo 타입이어도 사진이 삭제되면 텍스트타입으로
			if @post.photos.length == 0
				params[:post][:post_type] = "0"
			end
		end

		if params[:post][:post_type] == "0"
			@post.update(post_params)
			# show 로 전환될 경우 필요
			@comment = Comment.new 
			redirect_to @post
		else
			# 1이면 중간 사진 업로드를 위한 요청이 아닌, 완전히 끝낸다는 표시
			@isFinished = params[:finish]

			# 캡션은 이미 저장된 이미지에 대해서만 달 수 있어!
			# 캡션을 임시로 담고 있는 captions Hash 
			captions = JSON.parse(params[:captions])	
			@post.photos.each do |photo|
				# 이 조건문이 없으면 수정 사항이 아닌 것들이 다 초기화됨
				if captions[photo.id.to_s] 
					photo.update(caption: captions[photo.id.to_s])
				end
			end

			# 그 이외의 수정 사항 반영
			#if @post.update(params[:post].permit(:title, :content))
			if @post.update(post_params)
				# 추가적으로 넣은 이미지 저장하고
				if params[:images]
					params[:images].each do |image|
						@post.photos.create(image: image)
					end
				end
				# 완전 끝내는 거면
				if @isFinished == "1"
					# update.js 실행됨
					# show 로 전환될 경우 필요
					@comment = Comment.new 
					redirect_to @post
				else
				# finish가 0이면 
					render "edit"
				end
			else
			# 에러 있으면
				render "edit"
			end
		end 
	end
	"""
		업로드 기능 끝 
		업로드 기능 끝 
		업로드 기능 끝 
	"""

	def destroy
		@post = Post.find(params[:id])	
		@post.destroy
		redirect_to :back 
	end
	
	private
		def post_params
			params.require(:post).permit(:title, :content, :post_type, :project_id, :tag_list_fixed, :is_secret)
		end

end
