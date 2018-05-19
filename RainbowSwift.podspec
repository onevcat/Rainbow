Pod::Spec.new do |s|

  s.name         = "RainbowSwift"
  s.version      = "3.1.4"
  s.summary      = "`Rainbow` adds text color, background color and style for console and command line output in Swift."

  s.description  = <<-DESC
                      `Rainbow` adds text color, background color and style for console and command 
                      line output in Swift. It is born for cross platform software logging 
                      in terminals, working in both Apple's platforms and Linux. Meanwhile, it is also 
                      compatible with [XcodeColors](https://github.com/robbiehanson/XcodeColors), 
                      which lets you colorize the Xcode debugger output as well when developing an app.
                   DESC

  s.homepage     = "https://github.com/onevcat/Rainbow"
  s.screenshots  = "https://raw.githubusercontent.com/onevcat/Rainbow/assets/rainbow.png"

  s.license      = "MIT"
  s.author             = { "onevcat" => "onevcat@gmail.com" }
  s.social_media_url   = "https://twitter.com/onevcat"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  
  s.source       = { :git => "https://github.com/onevcat/Rainbow.git", :tag => s.version }

  s.source_files  = "Sources/"
  s.public_header_files = "Sources/Rainbow.h"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.swift_version = '4.0'
  s.static_framework = true
end
