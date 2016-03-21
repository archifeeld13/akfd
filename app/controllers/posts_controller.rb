class PostsController < ApplicationController
	# 보여주기 용으로 해논거임
	before_action :set_posts_users
	
  def index
		if params[:tag]
			# 태그 검색시 실행 부분
			@posts = Post.tagged_with(params[:tag])
			flash[:search_info] = "<strong class='text-danger'>#{params[:tag]}</strong> 에 대한 검색결과 입니다."
		else
			# 기본 메인 페이지
			@posts = Post.all.reverse
		end
  end
  
	def my_feeld
		# 회원 이름을 클릭해서 들어오면 /my_feeld?user_id=유저아이디
		# 형식으로 날라온다
		if params[:user_id]
			@user = User.find(params[:user_id])
			@posts = Post.where(user_id: params[:user_id]).reverse
			# 쿼리상에서 애초에 공유한것까지 같이 가져오는 방법은 없나?
			@shares = []
			@user.shares.each do |share|
				@shares.push(share.post)
			end
		# 마이필드 버튼을 클릭해서 /my_feeld로 접속했을 때 실행되는 부분 
		else 
			@user = User.find(current_user.id)
			@posts = Post.where(user_id: @user.id).reverse
			@shares = []
			@user.shares.each do |share|
				@shares.push(share.post)
			end
		end
	end

	def show
		@post = Post.find(params[:id])
		@comment = Comment.new # 이거 안적으니까 지난 시간 구하는거에서 에러나
		respond_to do |format|
			format.html { render :action => "show" }
			format.js { render :file => "posts/show.js.erb" }
		end
	end

  def new
		#@post = Post.new
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

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		if @post.save
			redirect_to posts_path, notice: 'Post was successfully created'
			#redirect_to @post, notice: 'Post was successfully created'
		else
			render 'new'
		end
	end

	def destroy
		@post = Post.find(params[:id])	
		@post.destroy
		redirect_to posts_path
	end
	
	private
		def post_params
			params.require(:post).permit(:title, :content, :project_id, {images: []}, :tag_list)
		end
		def set_posts_users
			@posts = Post.all
			@users = User.all
		end

end
