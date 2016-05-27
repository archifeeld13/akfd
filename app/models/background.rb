class Background < ActiveRecord::Base
	mount_uploader :photo, S3Uploader
	validates :photo, presence: true
	validates :author, :presence => true
end
