class Project < ActiveRecord::Base
  belongs_to :user
	mount_uploader :photo, S3Uploader
	has_many :posts, :dependent => :nullify
end
