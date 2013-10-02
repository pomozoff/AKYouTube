Pod::Spec.new do |s|
  s.name                  = "AKYouTube"
  s.version               = "0.0.3"
  s.summary               = "Simple REST client to YouTube v3 API"
  s.homepage              = "https://github.com/pomozoff/AKYouTube"
  s.license               = { :type => 'MIT', :file => 'FILE_LICENSE' }
  s.author                = { "Anton Pomozov" => "pomozoff@gmail.com" }
  s.platform              = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/pomozoff/AKYouTube.git", :tag => s.version.to_s }
  s.dependency 'EasyMapping', '~> 0.4.7'
  s.source_files          = 'Classes/*.{h,m}'
  s.public_header_files   = 'Classes/*.h'
  s.frameworks            = 'UIKit', 'Foundation'
  s.requires_arc          = true
end
