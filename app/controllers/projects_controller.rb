class ProjectsController < ApplicationController
	before_action :project_params, only: [:create]

	def new
		@project = Project.new 
	end

	def show
		@project = Project.find(params[:id])
		@user = @project.user
		@posts = @project.posts 
	end

	
  def create
		#@type = params[:project][:type]
		@project = current_user.projects.new(project_params)
		#@project = current_user.projects.new(name: params[:project][:name])
		if @project.save
			redirect_to my_feeld_path
		else
			render "projects/new"
		end
  end

	def edit
		@project = current_user.projects.find(params[:id])
	end

	def update
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
