class Post < ActiveRecord::Base
	has_many :comments, dependent: :destroy
	mount_uploaders :images, S3Uploader
	serialize :images, Array
end
