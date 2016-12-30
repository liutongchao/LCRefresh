

Pod::Spec.new do |s|

  s.name         = 'LCRefresh'
  s.version      = '0.1.12'
  s.summary      = "A Swift refresh tool used on iOS ."
  s.description  = <<-DESC
		   It is a Swift refresh tool used on iOS . which implement by Swift
                   DESC

  s.homepage     = "https://github.com/liutongchao/LCRefresh"
  s.license      = 'MIT'
  s.author       = { 'liutongchao' => '413281269@qq.com' }
  s.platform     = :ios, '8.0'

  s.source       = { :git => "https://github.com/liutongchao/LCRefresh.git", :tag => s.version }
  s.source_files  = "LCRefresh/*.swift"
  #s.exclude_files = "Classes/Exclude"
  #s.public_header_files = "Classes/**/*.swift"
  #s.public_header_files = "LCRefresh/LCRefresh/LCRefresh/*.swift"

  s.resources  = "LCRefresh/LCRefresh.bundle"
  # s.resources = "Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.frameworks = "Foundation", "UIKit"

  s.requires_arc = true

end
