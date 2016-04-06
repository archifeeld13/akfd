class Photo < ActiveRecord::Base
	belongs_to :post

	validates :post, presence: true

	mount_uploader :image, S3Uploader
end
