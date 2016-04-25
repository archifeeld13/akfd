class Post < ActiveRecord::Base
	# post_type 0 : text, 1: image , 2: link
	has_many :comments, dependent: :destroy
	has_many :likes, dependent: :destroy
	has_many :shares, dependent: :destroy
	has_many :shared_users, class_name: 'User', through: :shares, source: :user

	has_many :events, dependent: :destroy

	# Post has many photos
	has_many :photos, :inverse_of => :post, :dependent => :destroy
	# enable nested attributes for photos through album class
	accepts_nested_attributes_for :photos, allow_destroy: true

	belongs_to :user
	belongs_to :project

	acts_as_taggable

	#validates :title, presence: true

	def tag_list_fixed
		tag_list.to_s
	end

	def tag_list_fixed=(tag_list_string)
		self.tag_list = tag_list_string
	end
end
