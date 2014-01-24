Pod::Spec.new do |s|
  s.name         = "UIImageView-FastImageCache"
  s.version      = "0.1.0"
  s.summary      = "A Simple Wrapper With FastImageCache (released by Path Inc)"
  s.description  = <<-DESC
                    UIImageView+FastImageCache

                    * Markdown format.
                    * Don't worry about the indent, we strip it!
                   DESC
  s.homepage     = "https://github.com/pan286/UIImageView-FastImageCache"
  s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "pan286" => "pan286@gmail.com" }
  s.source       = { :git => "https://github.com/pan286/UIImageView-FastImageCache.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes/ios/*.{h,m}'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/UIImageView+FastImageCache.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  s.dependency 'FastImageCache', '~> 1.2'
end