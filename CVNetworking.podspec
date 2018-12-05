Pod::Spec.new do |s|
  s.name         = "CVNetworking"    #存储库名称
  s.version      = "1.0.0"      #版本号，与tag值一致
  s.summary      = "CVNetworking"  #简介
  s.swift_version= "4.2"
  s.description  = "网络请求类，二次封装Alamofire，支持GET,POST,PUT等，支持上传图片"  #描述
  s.homepage     = "https://github.com/weixhe/CVNetworking"      #项目主页，不是git地址
  s.license      = { :type => "MIT", :file => "LICENSE" }   #开源协议
  s.author       = { "weixhe" => "workerwei@163.com" }  #作者
  s.platform     = :ios, "8.0"                  #支持的平台和版本号
  s.source       = { :git => "https://github.com/weixhe/CVNetworking.git", :tag => "1.0.0" }         #存储库的git地址，以及tag值
  s.source_files =  "CVNetworking/CVNetworking/CVNetworking.swift" #需要托管的源代码路径
  s.requires_arc = true #是否支持ARC

  s.dependency "Alamofire"    #所依赖的第三方库，没有就不用写
  s.dependency "CVSwiftyLoad"    #所依赖的第三方库，没有就不用写

  # 组件 BaseApiManager
  s.subspec 'BaseApiManager' do |ss|
    ss.source_files = "CVNetworking/CVNetworking/BaseApiManager/*.{swift}"
  end

  # 组件 Services
  s.subspec 'Services' do |ss|
    ss.source_files = "CVNetworking/CVNetworking/Services/*.{swift}"
  end

  # 组件 URLResponse
  s.subspec 'URLResponse' do |ss|
    ss.source_files = "CVNetworking/CVNetworking/URLResponse/*.{swift}"
  end

  # 组件 Reachability
  s.subspec 'Reachability' do |ss|
    ss.source_files = "CVNetworking/CVNetworking/Reachability/*.{swift, h, m}"
  end

  # 组件 Cache
  s.subspec 'Cache' do |ss|
    ss.source_files = "CVNetworking/CVNetworking/Cache/*.{swift}"
  end
  
end
