class PostsController < ApplicationController
	require 'json'
	before_action :check_logined, only: [:timeline, :message_box, :new, :create, :edit, :update, :destroy]

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
			flash[:notice] = "전체 포스트를 최근 작성순으로 보여줍니다 :D"
		end
  end

	def timeline 
		@selected = "timeline"
		@posts = []
		current_user.friendships.each do |f| 
			f.friend.posts.each do |p|
				@posts << p
			end
		end

		current_user.posts.each do |p|
			@posts << p
		end

		# 미래에는 메모리에 안올라오는 날이 있을 듯
		# 미래에는 메모리에 안올라오는 날이 있을 듯
		@posts = @posts.sort_by{|p| p.created_at}.reverse
		flash[:notice] = "친구들의 필드업을 보여줍니다;D"
	end
  

=begin
	my_feeld 에 속하는 기능들
		- message_box
		- archive_mine
		- archive_share
		- project_management
=end
	def my_feeld
		# 회원 이름을 클릭해서 들어오면 /my_feeld?user_id=유저아이디
		# 형식으로 날라온다
		if params[:user_id]
			@user = User.find(params[:user_id])
			@posts = Post.where(user_id: params[:user_id], is_secret: false).reverse
		# 마이필드 버튼을 클릭해서 /my_feeld로 접속했을 때 실행되는 부분 
		# login_check를 쓰지않고 직접 체크해야 하는 상황
		elsif session[:user_id] 
			@user = User.find(current_user.id)
			@posts = Post.where(user_id: @user.id).reverse
		else
			redirect_to login_path
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
		if params[:user_id]
			@posts = Post.where(user_id: User.find(params[:user_id]).id).reverse
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
		if params[:user_id] and (!current_user or (User.find(params[:user_id]).id != current_user.id))
			@isMine = false
			@projects = Project.where(user_id: User.find(params[:user_id]).id).reverse
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
		respond_to do |format|
			format.html { render :action => "show" }
			format.js { render :file => "posts/show.js.erb" }
		end
	end

  def new
		@post = Post.new
		respond_to do |format|
			format.html { render :action => "new" }
			modal_type = params[:type]
			case modal_type	
				when 'text' then format.js { render :file => "posts/textup.js.erb" }
				when 'link' then format.js { render :file => "posts/linkup.js.erb" }
				when 'photo' then format.js { render :file => "posts/photoup.js.erb" }
			end
		end
  end

	def edit
		@post = Post.find(params[:id])	
	end

	def create
		# 
		# post_type // 0:text, 1:img, 2:link
		#
		
		# link param이 있을 때는 링크업이다
		if params[:link] 
			# title, content , link_url 초기화
			@post = Post.new(post_params)
			@link = params[:link]			
			@object = LinkThumbnailer.generate(params[:link])

		# 그 이외에는 텍스트업 혹은 포토업이다
		else 
			@post = Post.new(post_params)
			#@post.title = "제목 없음" if @post.title.length == 0
			#@post.content= "내용 없음" if @post.content.length == 0
			@post.user_id = current_user.id
			@post.save

			# 이미지 타입일 경우엔 이미지 저장도 해준다
			if @post.post_type == 1 
				if params[:images]
					params[:images].each do |image|
						#image.original_filename 
						@post.photos.create(image: image)
					end
				end
			end

			# show 로 전환될 경우 필요
			@comment = Comment.new 
		end

	end

	def update
		@post = Post.find(params[:id])
		if @post.post_type == 0
			@post.update(post_params)
			# show 로 전환될 경우 필요
			@comment = Comment.new 
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
				if params[:images]
					params[:images].each do |image|
						@post.photos.create(image: image)
					end
				end
				if @isFinished == "1"
					# update.js 실행됨
					# show 로 전환될 경우 필요
					@comment = Comment.new 
				else
					render :edit 
				end
			else
				render :edit
			end
		end 
	end

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
