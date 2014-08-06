Pod::Spec.new do |s|
  s.name         = "AYImageView"
  s.version      = "0.0.5"
  s.summary      = "Rounded async imageview downloader based on SDWebImage."
  s.homepage     = "https://github.com/AYastrebov/AYImageView"
  s.license      = 'MIT'
  s.author       = { "Andrey Yastrebov" => "ayastrebov@gmail.com" }
  s.source       = { :git => "https://github.com/AYastrebov/AYImageView.git", :tag => "v0.0.5" }
  s.platform     = :ios, '6.0'
  s.source_files = 'AYImageView.{h,m}'
  s.requires_arc = true
  s.dependency 'SDWebImage', '~> 3.6'
end
