# http://www.sitepoint.com/rails-authentication-oauth-2-0-omniauth/
# https://github.com/mkdynamic/omniauth-facebook
Rails.application.config.middleware.use OmniAuth::Builder do 
	#provider :facebook, '388357157955370', '7c8974e1b3a873622039d04c8a9766f1',
	provider :facebook, ENV['FB_ID'], ENV['FB_KEY'],
		scope: 'public_profile'
	#	scope: 'public_profile,email', info_fields: 'email,name'
	#https://github.com/mkdynamic/omniauth-facebook/issues/61
end
