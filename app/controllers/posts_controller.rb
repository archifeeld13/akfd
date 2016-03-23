class PostsController < ApplicationController
	# 보여주기 용으로 해논거임
	before_action :set_posts_users

  def index
		if params[:tag]
			# 태그 검색시 실행 부분
			@posts = Post.tagged_with(params[:tag])
			flash[:notice] = "<strong class='text-danger'>#{params[:tag]}</strong> 에 대한 검색결과 입니다."
		else
			# 기본 메인 페이지
			@posts = Post.all.reverse
			flash[:notice] = "아키필드에 오신 것을 환영합니다!<span style='color:red'>♥</span>"
		end
  end
  
	def my_feeld
		# 회원 이름을 클릭해서 들어오면 /my_feeld?user_id=유저아이디
		# 형식으로 날라온다
		if params[:user_id]
			@user = User.find(params[:user_id])
			@posts = Post.where(user_id: params[:user_id]).reverse
		# 마이필드 버튼을 클릭해서 /my_feeld로 접속했을 때 실행되는 부분 
		else 
			@user = User.find(current_user.id)
			@posts = Post.where(user_id: @user.id).reverse
		end
	end

	#
	# archive_mine, archive_share, project_list -> ajax
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
		# shared post -> 최효성님이 조언주신대로 바꾸기
		@posts = []
		if params[:user_id]
			User.find(params[:user_id]).shares.each do |share|
				@posts.push(share.post)	
			end
		else
			current_user.shares.each do |share|
				@posts.push(share.post)	
			end
		end
		@posts.reverse!
	end

	def project_list
		if params[:user_id]
			@projects = Project.where(user_id: User.find(params[:user_id]).id).reverse
		else
			@projects = Project.where(user_id: current_user.id).reverse
		end
	end

	def project_list_in
		project = Project.find(params[:project_id])
		@posts = project.posts
		@projects = [project] 
		# 1개짜리 배열, projects/_project.html.erb 재활용위해..
		# 그 안에서 @projects에 대해 each문 돌림
	end
	#
	# archive_mine, archive_share, project_list -> ajax
	# in my_feeld
	# 

	def show
		@post = Post.find(params[:id])
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
		# textup타입만 됨
	end

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		if @post.save
			redirect_to :back, notice: 'Post was successfully created'
		else
			render 'new'
		end
	end

	def update
		@post = Post.find(params[:id])
		@post.update(post_params)
		redirect_to posts_path
	end

	def destroy
		@post = Post.find(params[:id])	
		@post.destroy
		redirect_to posts_path
	end
	
	private
		def post_params
			params.require(:post).permit(:title, :content, :project_id, {images: []}, :tag_list_fixed)
		end
		def set_posts_users
			@posts = Post.all
			@users = User.all
		end

end
