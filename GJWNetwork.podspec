Pod::Spec.new do |s|

  s.name         = "GJWNetwork"
  s.version      = "0.0.1"
  s.summary      = "基于AFNetworking封装的简单易用网络库，提供了常用的API,基于AFN3.0封装的"

  # s.description  = <<-DESC
                   DESC

  s.homepage     = "http://github.com/SoftBoys/GJWNetwork"
  

  s.license      = "MIT"

  s.author             = { “guojunwei” => “gjw_1991@163.com” }
  # Or just: s.author    = "guojunwei"
  # s.authors            = { "guojunwei" => "" }
  # s.social_media_url   = "http://www.jianshu.com/users/d5a5bbd63156/latest_articles"

  s.platform     = :ios, '7.0'


  s.source       = { :git => "http://github.com/SoftBoys/GJWNetwork.git", :tag => "v#{s.version}" }


  s.source_files  = "GJWNetwork/*.{h,m}"
 
  s.requires_arc = true

  s.dependency 'AFNetworking', '~> 3.0.4'

end
