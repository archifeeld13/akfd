class User < ActiveRecord::Base

class << self
	def from_omniauth(auth_hash)
		user = find_or_create_by(uid: auth_hash['uid'])
		user.name = auth_hash['info']['name']
		user.image_url = auth_hash['info']['image']
		user.save!
		user
	end
end
end
