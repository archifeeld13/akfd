class PostsController < ApplicationController
	require 'json'
	before_action :check_logined, only: [:new, :timeline, :message_box, :create, :edit, :update, :destroy]

	def notice
			render "/posts/notice", :layout => 'notice' 
	end

	def tag_search
		@reco_tags = ActsAsTaggableOn::Tag.where("name like ?", "%#{params[:tag]}%")
		@reco_tags= @reco_tags.sort_by{|p| p.taggings_count}.reverse
		render json: @reco_tags
	end

  def index
		# default post type 1
		p_t= 1

		if params[:tag]
		# 태그 검색
			# secret인건 따로 제거 보여줄때 제거?
			@posts = Post.tagged_with(params[:tag])
										.order(created_at: :desc)
										.paginate(page: params[:page], per_page: 20)

			#flash[:notice] = "<strong class='text-danger'>#{params[:tag]}</strong> 에 대한 검색결과 입니다."
		else
			if params[:type]
				if params[:type] == "works"
					p_t = 1 
				'''
				elsif params[:type] == "community"
					p_t = 0 
				elsif params[:type] == "connect"
					p_t = 3
				'''
				end
				@posts = Post.where(post_type:p_t, is_secret: false)
											.order(created_at: :desc)
											.paginate(page: params[:page], per_page: 20)
			else 
				# 타입이 없을 경우 실행되는 부분
				p_t = 1
				@posts = Post.where(post_type:p_t, is_secret: false)
											.order(created_at: :desc)
											.paginate(page: params[:page], per_page: 20)
			end
		end

		respond_to do |format|
		 format.html
		 format.js
		end
  end

	def connects
		p_t = 3
		@posts = Post.where(post_type:p_t, is_secret: false)
									.order(created_at: :desc)
									.paginate(page: params[:page], per_page: 20)
	end

	def community
		p_t = 0 
		@posts = Post.where(post_type:p_t, is_secret: false)
									.order(created_at: :desc)
									.paginate(page: params[:page], per_page: 20)
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
	def mf_redirect
		user = User.where(mf_id: params[:mf_id])[0]
		redirect_to "/my_feeld/#{user.id}" 
	end

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

			if params[:filter] == 'archive'
				@posts = Post.where(user_id: User.find(params[:user_id]).id, is_secret: false, post_type: 1)
											.order(created_at: :desc)
											.paginate(page: params[:page], per_page: 20)

			elsif params[:filter] == 'collection'
				@posts = Post.where(user_id: User.find(params[:user_id]).id, is_secret: false, post_type: 2)
											.order(created_at: :desc)
											.paginate(page: params[:page], per_page: 20)

			elsif params[:filter] == 'binder'
				@projects = Project.where(user_id: @user.id).reverse

			else 
				@posts = Post.where(user_id: User.find(params[:user_id]).id, is_secret: false)
											.order(created_at: :desc)
											.paginate(page: params[:page], per_page: 20)
				@projects = Project.where(user_id: @user.id).reverse
			end

			@isMine = false
		else
			@user = User.find(current_user.id)

			if params[:filter] == 'archive'
				@posts = Post.where(user_id: current_user.id, post_type: 1 )
											.order(created_at: :desc)
											.paginate(page: params[:page], per_page: 20)

			elsif params[:filter] == "collection"
				@posts = Post.where(user_id: current_user.id, post_type: 2 )
											.order(created_at: :desc)
											.paginate(page: params[:page], per_page: 20)


			elsif params[:filter] == 'binder'
				@projects = Project.where(user_id: current_user.id).reverse

			else
				@posts = Post.where(user_id: current_user.id)
											.order(created_at: :desc)
											.paginate(page: params[:page], per_page: 20)
				@projects = Project.where(user_id: current_user.id).reverse
			end

			@isMine = true 
		end
		respond_to do |format|
		 format.html
		 format.js
		end
	end

	def message_box
		# 나중에 메시지 보내는 용도로 쓸 것임
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
		@posts = @posts.flatten.delete_if{|p| p.id == @post.id or p.is_secret == true}.shuffle[0..9].uniq

		@isReco = false 
		if @posts.length > 0
			@isReco = true
		else
			@posts = Post.where(is_secret:false).reverse[0..30].shuffle[0..9]
		end

		# secret false 제외 시켜야됌
		#@posts = Post.where(post_type: post_type, is_secret: false).reverse

		respond_to do |format|
			if @post.post_type == 1
				format.html { render :action => "show" }
			else 
				format.html { render :action => "show_simple" }
			end
			#format.js { render :file => "posts/show.js.erb" }
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
				@isNew = true
				format.html { render :action => "new" }
			end
		end
  end

	def edit
		@post = Post.find(params[:id])	
		# 매니저 리스트에 포함 안되면 참(접근 불가), 아이디가 달라도 접근 불가
		if (current_user.id != @post.user.id) 
			if not (manager_list.include? current_user.id)
				redirect_to root_path 
			end
		end
	end

	def link_create
		# linkinput을 했을 때 오는곳 (따로 컨트롤러 만들지 않았다)
		@link = params[:link]
		@object = LinkThumbnailer.generate(params[:link])
		@post = Post.new
	end

	def create
		# 
		# post_type // 0:community , 1:works, 2:link, 3:connect
		#
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		# 버그가 있어서? 따로 받아서 저장해줌 모델과 관계없는 파라미터 전달 방식으로
		@post.post_type = params[:post_type]
		@post.save

		# 이미지가 있다면 이미지 저장
		if params[:images]
			params[:images].each do |image|
				#image.original_filename 
				@post.photos.create(image: image)
			end
		end
		#end

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

		if params[:images]
			# 이미지 타입의 경우 수정으로 리다이렉트
			render "edit"
		else 
			redirect_to @post
		end
	end

	def update
		# 현재는 링크업 수정 안됨
		@post = Post.find(params[:id])
		@post.post_type = params[:post_type]
		@post.save

		# 사실 이미지가 없는 채로 여기 왔다는거 자체가 isFinished 0 아닌가?
		if params[:images]
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
			if @post.update(post_params)
				# 추가적으로 넣은 이미지 저장하고
				if params[:images]
					params[:images].each do |image|
						@post.photos.create(image: image)
					end
				end

				render "edit"
				'''
				# 완전 끝내는 거면
				if @isFinished == "1"
					# show 로 전환될 경우 필요
					@comment = Comment.new 
					redirect_to @post
				else
				# finish가 0이면 
					render "edit"
				end
				'''
			else
			# 에러 있으면
				render "edit"
			end
		else
			@post.update(post_params)
			# show 로 전환될 경우 필요
			@comment = Comment.new 
			redirect_to @post
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
			params.require(:post).permit(:title, :content, :project_id, :tag_list_fixed, :is_secret)
		end

end
