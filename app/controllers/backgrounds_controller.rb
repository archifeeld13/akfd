class BackgroundsController < ApplicationController
  def new
		@background = Background.new 		
  end

  def create
		@background = Background.new(back_params)
		if @background.save
			bgs = Background.all
			bgs.each do |bg|
				if bg.id < @background.id
					bg.destroy
				end
			end
			redirect_to login_path
		else
			redirect_to :back	
		end
  end

private
	def back_params
		params.require(:background).permit(:photo, :author)
	end
end
