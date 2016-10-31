class User < ActiveRecord::Base
	has_one :email_auth, dependent: :destroy

	has_many :comments, dependent: :destroy
	has_many :posts, dependent: :destroy
	has_many :projects, dependent: :destroy

	has_many :likes, dependent: :destroy
	has_many :shares, dependent: :destroy
	has_many :shared_posts, class_name: 'Post', through: :shares, source: :post


	# 유저가 삭제되면 그 친구가 관계하고 있는 프렌쉽 자체도 삭제되어야함
	has_many :friendships, dependent: :destroy
	has_many :friends, :through => :friendships
	has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id", dependent: :destroy
	has_many :inverse_friends, :through => :inverse_friendships, :source => :user	

	has_many :events, dependent: :destroy
	has_many :inverse_events, class_name: "Event", foreign_key: "target_id"

	mount_uploader :photo, S3Uploader

	# https://github.com/mbleigh/acts-as-taggable-on
	acts_as_taggable_on :skills
	def skill_list_fixed
		skill_list.to_s
	end

	def skill_list_fixed=(skill_list_string)
		self.skill_list = skill_list_string
	end


	# 페이스북 로그인시 유저 생성할 때도 관여하네..
	EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
	# 일단 패스워드가 nil이 아니란 소리는 직접 가입한다는 소리니까..
	with_options unless: 'password.nil?' do |ok|
		ok.validates :name, :presence => true, :length => {:in => 2..15, message: '이름은 15자리 이하로 작성해 주세요'}
		ok.validates :email, :presence => true, :uniqueness => { message: '이미 존재하는 이메일 주소입니다' }, format: {with: EMAIL_REGEX} 
		ok.validates :password, :confirmation => {message: '비밀번호가 일치하지 않습니다'} 
		#ok.validates_length_of :password, :in => 1..20, :on => :create
	end 

class << self
	def from_omniauth(auth_hash)
		user = find_or_create_by(uid: auth_hash['uid'])
		user.name = auth_hash['info']['name']
		user.image_url = auth_hash['info']['image']
		user.user_type = 1 # 0은 기본유저, 1은 페북유저
		user.save!
		user
	end
end
end
