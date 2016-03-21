class Post < ActiveRecord::Base
	has_many :comments, dependent: :destroy
	has_many :likes, dependent: :destroy
	has_many :shares, dependent: :destroy

	belongs_to :user
	belongs_to :project

	mount_uploaders :images, S3Uploader
	serialize :images, Array

	acts_as_taggable
end
