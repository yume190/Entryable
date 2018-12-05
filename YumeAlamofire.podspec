Pod::Spec.new do |s|
  s.name     = 'YumeAlamofire'
  s.version  = '4.2.2'
  s.license  = 'MIT'
  s.summary  = "A Library combine network request and json decode in POP way"
  s.homepage = 'https://github.com/yume190/YumeAlamofire'
  s.authors  = { 'yume190' => 'yume190@gmail.com' }
  s.social_media_url = "https://www.facebook.com/yume190"
  s.source   = { :git => 'https://github.com/yume190/YumeAlamofire.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  # s.osx.deployment_target = '10.11'
  
  # s.tvos.deployment_target = '9.0'
  # s.watchos.deployment_target = '2.0'
  s.source_files = ['Sources/YumeAlamofire/*.swift']

  # s.swift_version = '4.2'
  s.static_framework = true

  s.dependency "Alamofire", "~> 4.7.3"
  s.dependency "JSONDecodeKit", "~> 4.1.0"
  s.dependency 'AwaitKit', '~> 5.0.1'
  # s.dependency 'PromiseKit', '~> 6.5.2'
end
