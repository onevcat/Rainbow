Pod::Spec.new do |s|

  s.name         = "Rainbow"
  s.version      = "0.0.1"
  s.summary      = "Rainbow adds methods to set text color, background color and style for Swift console and command line output, for both Apple's platforms and Linux."

  s.description  = <<-DESC
                    Rainbow adds methods to set text color, background color and style for Swift console and command line output, for both Apple's platforms and Linux. It is born for cross platform software logging in terminals. Meanwhile, it is also compatible with XcodeColors, which lets you use it in Xcode to colorize the debugger output as well.
                   DESC

  s.homepage     = "https://github.com/onevcat/Rainbow"
  s.screenshots  = "https://raw.githubusercontent.com/onevcat/Rainbow/assets/rainbow.png"

  s.license      = "MIT"
  s.author             = { "onevcat" => "onevcat@gmail.com" }
  s.social_media_url   = "http://twitter.com/onevcat"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  
  s.source       = { :git => "https://github.com/onevcat/Rainbow.git", :tag => s.version }

  s.source_files  = "Sources/"
  s.public_header_files = "Sources/Rainbow.h"
end
