class Project < ActiveRecord::Base
  belongs_to :user
	has_many :posts, :dependent => :nullify
end
