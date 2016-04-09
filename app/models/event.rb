class Event < ActiveRecord::Base
	# post쪽에서 여기로 올필욘 없어서has_many안저금
  belongs_to :post
	belongs_to :user
	belongs_to :target, :class_name => "User"
end
