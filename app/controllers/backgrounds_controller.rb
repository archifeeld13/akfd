class BackgroundsController < ApplicationController
  def new
		@background = Background.new 		
  end

  def create
		@background = Background.new(back_params)
		if @background.save
			redirect_to login_path
		else
			#redirect_to :back	
			render text: "에러"
		end
  end

	def destroy
		@bg= Background.find(params[:id])	
		@bg.destroy
		redirect_to :back 
	end

private
	def back_params
		params.require(:background).permit(:photo, :author)
	end
end
