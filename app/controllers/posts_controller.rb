class PostsController < ApplicationController
	# 보여주기 용으로 해논거임
	before_action :set_posts_users
	
  def index
		# 이부분은 나중에 바뀔 수가 있다.
		@posts = Post.all.reverse
  end
  
	def my_feeld
		@posts = Post.where(user_id: current_user.id).reverse
		# user.shares, post.shares
		# share_object.user, share_object.post
		@shares = []
		current_user.shares.each do |share|
			@shares.push(share.post)
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
			redirect_to @post, notice: 'Post was successfully created'
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
			params.require(:post).permit(:title, :content, {images: []})
		end
		def set_posts_users
			@posts = Post.all
			@users = User.all
		end

end
