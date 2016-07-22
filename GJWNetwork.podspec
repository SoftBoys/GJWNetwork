Pod::Spec.new do |s|

  s.name         = "GJWNetwork"
  s.version      = "0.1.0"
  s.summary      = "基于AFNetworking封装的下载类库"
  s.homepage     = "https://github.com/SoftBoys/GJWNetwork"
  s.license      = "MIT"
  s.author       = { "gjw" => "gjw_1991@163.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/SoftBoys/GJWNetwork.git", :tag => s.version }
  s.source_files  = "GJWNetwork"
  s.requires_arc = true
  s.dependency "AFNetworking", "~> 3.0.0"


end
