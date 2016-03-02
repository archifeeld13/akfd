class WelcomeController < ApplicationController
  def index
		@posts = Post.all
		@users = User.all
  end
end
