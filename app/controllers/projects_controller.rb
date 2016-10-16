class ProjectsController < ApplicationController
	before_action :project_params, only: [:create]

	def new
	end

	def show
		@project = Project.find(params[:id])
		@user = @project.user
		@posts = @project.posts 
	end

	# ajax로 프로젝트만 생성하는 곳이다
  def create
		@type = params[:project][:type]
		#@project = current_user.projects.new(project_params)
		@project = current_user.projects.new(name: params[:project][:name])
		@project.save
  end

  def destroy
		@project = current_user.projects.find(params[:id])
		@project.destroy
  end

private
	def project_params
		params.require(:project).permit(:name, :type)
	end
end
