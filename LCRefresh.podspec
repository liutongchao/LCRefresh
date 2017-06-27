

Pod::Spec.new do |s|

  s.name         = 'LCRefresh'
  s.version      = '0.1.16'
  s.summary      = "A Swift refresh tool used on iOS ."
  s.description  = <<-DESC
		   It is a Swift refresh tool used on iOS . which implement by Swift
                   DESC

  s.homepage     = "https://github.com/liutongchao/LCRefresh"
  s.license      = 'MIT'
  s.author       = { 'liutongchao' => '413281269@qq.com' }
  s.platform     = :ios, '8.0'

  s.source       = { :git => "https://github.com/liutongchao/LCRefresh.git", :tag => s.version }
  s.source_files  = "Source/*.swift"

  s.resources  = "Source/LCRefresh.bundle"

  s.frameworks = "Foundation", "UIKit"

  s.requires_arc = true

end
