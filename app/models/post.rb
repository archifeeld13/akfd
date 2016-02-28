class Post < ActiveRecord::Base
	mount_uploaders :images, S3Uploader
	serialize :images, Array
end
