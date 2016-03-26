class Post < ActiveRecord::Base
	# post_type 0 : text, 1: image , 2: link
	has_many :comments, dependent: :destroy
	has_many :likes, dependent: :destroy
	has_many :shares, dependent: :destroy
	has_many :shared_users, class_name: 'User', through: :shares, source: :user

	belongs_to :user
	belongs_to :project

	mount_uploaders :images, S3Uploader
	serialize :images, Array

	acts_as_taggable

	def tag_list_fixed
		tag_list.to_s
	end

	def tag_list_fixed=(tag_list_string)
		self.tag_list = tag_list_string
	end
end
