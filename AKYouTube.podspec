Pod::Spec.new do |s|
  s.name         = "AKYouTube"
  s.version      = "0.0.1"
  s.summary      = "Simple REST client to YouTube v3 API"
  s.homepage     = "https://github.com/pomozoff/AKYouTube"
  s.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }
  s.author       = { "Anton Pomozov" => "pomozoff@gmail.com" }
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/pomozoff/AKYouTube.git", :commit => "a73818e676de93f2e29380146760fb97cf71efc0" }
  s.source_files  = 'Classes/*.{h,m}'
  s.public_header_files = 'Classes/*.h'
  s.framework  = 'UIKit'
  s.requires_arc = true
  s.dependency 'EasyMapping', '~> 0.4.7'
end
