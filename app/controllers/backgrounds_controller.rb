class BackgroundsController < ApplicationController
	#http_basic_authenticate_with name: ENV['BG_ID'], password: ENV['BG_PW'], except: [:index, :show]
	http_basic_authenticate_with name: ENV['BG_ID'], password: ENV['BG_PW']

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
