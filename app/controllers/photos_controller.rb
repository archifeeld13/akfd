class PhotosController < ApplicationController
  def destroy
		@photo= Photo.find(params[:id])	
		@photo.destroy
  end
end
