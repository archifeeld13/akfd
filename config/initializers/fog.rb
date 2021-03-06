CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['S3_ID'],                        # required
    aws_secret_access_key: ENV['S3_KEY'],                        # required
    region:                'ap-northeast-2',             # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'seoularchifeeld'            # required
end
