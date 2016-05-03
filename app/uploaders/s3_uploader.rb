class S3Uploader < CarrierWave::Uploader::Base

	# 이미지를 조정할 수 있는 툴 설정
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

	# 이미지를 저장할 장소의 종류를 설정
  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

	# 이미지가 저장되는 위치
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

	# 요청한 이미지가 없을 때 대체해서 사용하는 default 이미지 설정
  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    #ActionController::Base.helpers.asset_path("fallback/" + [:thumb, "default.png"].compact.join('_'))
    #"/images/fallback/" + [version_name, "default.png"].compact.join('_')
    "default.png"
  end

	# 저장할 이미지 사이즈 조정
  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

	# 여러가지 이미지의 버전 설정 
  # Create different versions of your uploaded files:
	process :resize_to_fit => [1500, 1500]
  version :thumb do
    process resize_to_fit: [200, 200]
  end
	version :medium do
    process resize_to_fit: [400, 400]
  end

	# 저장될 파일들의 확장자 설정
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

	# 저장되는 파일의 이름 설정
  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
