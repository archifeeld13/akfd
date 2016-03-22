class ProjectsController < ApplicationController
	before_action :project_params, only: [:create]

	# ajax로 프로젝트만 생성하는 곳이다
  def create
		@project = current_user.projects.new(project_params)
		@project.save
  end

  def destroy
		@project = current_user.projects.find(params[:id])
		@project.destroy
  end

private
	def project_params
		params.require(:project).permit(:name)
	end
end
