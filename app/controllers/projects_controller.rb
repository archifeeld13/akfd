class ProjectsController < ApplicationController
	before_action :project_params, only: [:create]

	def new
		@project = Project.new 
	end

	def show
		@project = Project.find(params[:id])
		@user = @project.user
		# 지금 조회자가 본인이라면
		@posts = @project.posts
	end

	
  def create
		#@type = params[:project][:type]
		@project = current_user.projects.new(project_params)
		@project.save
  end

	def edit
		@project = current_user.projects.find(params[:id])
	end

	def update
		@project = Project.find(params[:id])
		if @project.update(project_params)
			redirect_to "/projects/#{@project.id}" 
		else
			render "projects/#{@project.id}/edit"
		end
	end

  def destroy
		@project = current_user.projects.find(params[:id])
		@project.destroy
		redirect_to my_feeld_path
  end

private
	def project_params
		params.require(:project).permit(:name, :tag_list_fixed, :desc, :photo )
	end
end
