Pod::Spec.new do |s|
  s.name         = "PAImageView"
  s.version      = "0.0.3"
  s.summary      = "Rounded async imageview downloader based on SDWebImage."
  s.homepage     = "https://github.com/AYastrebov/PAImageView"
  s.license      = { :type => 'MIT' }
  s.author       = { "Andrey Yastrebov" => "me@ayastrebov.com" }
  s.source       = { :git => "git@github.com:AYastrebov/PAImageView.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.source_files = 'PAImageView.{h,m}'
  s.requires_arc = true
  s.dependency 'SDWebImage', '~> 3.6'
end
