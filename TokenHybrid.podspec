Pod::Spec.new do |s|
  s.name         = "TokenHybrid"
  s.version      = "1.0.5"
  s.summary      = "A tool to build hybrid app"
  s.description  = "A tool help you build native app with html,css,js and build hybrid app without a server for independent developer"
  s.homepage     = 'https://github.com/cx478815108/TokenHybrid'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'chenxiong' => 'feelings0811@wutnews.net' }
  s.source       = { :git => 'https://github.com/cx478815108/TokenHybrid.git', :tag => 'v1.0.5' }

  s.ios.deployment_target = '9.0'
  s.requires_arc = true

  s.source_files = "Source/**/*.{h,m}"
  s.resources    = 'Source/JavaScriptSupport/Scripts/TokenBase.js'
  s.frameworks   = 'Foundation', 'UIKit', 'JavaScriptCore'
  s.dependency "YogaKit"
  s.dependency "SDWebImage"
  s.dependency "MJRefresh"
  s.dependency "UITableView+FDTemplateLayoutCell"
  s.dependency "TokenNetworking"
end
