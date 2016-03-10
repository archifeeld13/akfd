class Post < ActiveRecord::Base
	has_many :comments, dependent: :destroy
	has_many :likes, dependent: :destroy
	belongs_to :user

	mount_uploaders :images, S3Uploader
	serialize :images, Array
end
