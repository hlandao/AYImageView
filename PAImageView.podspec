Pod::Spec.new do |s|
  s.name         = "PAImageView"
  s.version      = "0.0.2"
  s.summary      = "Rounded async imageview downloader based on AFNetworking 2 and lightly cached."
  s.homepage     = "https://github.com/AYastrebov/PAImageView"
  s.license      = { :type => 'MIT' }
  s.author       = { "Andrey Yastrebov" => "me@ayastrebov.com" }
  s.source       = { :git => "git@github.com:AYastrebov/PAImageView.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.source_files = 'PAImageView.{h,m} SPMImageCache.{h,m}'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.2'
end
