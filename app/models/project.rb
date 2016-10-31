class Project < ActiveRecord::Base
  belongs_to :user
	mount_uploader :photo, S3Uploader
	has_many :posts, :dependent => :nullify

	acts_as_taggable
	def tag_list_fixed
		tag_list.to_s
	end

	def tag_list_fixed=(tag_list_string)
		self.tag_list = tag_list_string
	end

end
