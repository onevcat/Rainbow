![Rainbow](https://raw.githubusercontent.com/onevcat/Rainbow/assets/rainbow.png)

<p align="center">
<a href="https://travis-ci.org/onevcat/Rainbow"><img src="https://img.shields.io/travis/onevcat/Rainbow/master.svg"></a>
<a href="https://codecov.io/github/onevcat/Rainbow?branch=master"><img src="https://img.shields.io/codecov/c/github/onevcat/Rainbow.svg"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-ready-orange.svg"></a>
<a href="http://cocoadocs.org/docsets/RainbowSwift"><img src="https://img.shields.io/cocoapods/v/RainbowSwift.svg?style=flat"></a>
<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
<a href="http://cocoadocs.org/docsets/RainbowSwift"><img src="https://img.shields.io/badge/platform-ios%7Cosx%7Cwatchos%7Ctvos%7Clinux-lightgrey.svg"></a>
<a href="https://raw.githubusercontent.com/onevcat/Rainbow/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/RainbowSwift.svg?style=flat"></a>
</p>

`Rainbow` adds text color, background color and style for console and command 
line output in Swift. It is born for cross platform software logging 
in terminals, working in both Apple's platforms and Linux.

## Usage

Nifty way, using the `String` extension, and print the colorized string:

```swift
import Rainbow

print("Red text".red)
print("Blue background".onBlue)
print("Light green text on white background".lightGreen.onWhite)

print("Underline".underline)
print("Cyan with bold and blinking".cyan.bold.blink)

print("Plain text".red.onYellow.bold.clearColor.clearBackgroundColor.clearStyles)
```

It will give you something like this:

![](http://i.imgur.com/BUSJxPv.png)

You can also use the more verbose way if you want:

```swift
import Rainbow
let output = "The quick brown fox jumps over the lazy dog"
                .applyingCodes(Color.red, BackgroundColor.yellow, Style.bold)
print(output) // Red text on yellow, bold of course :)
```

## Motivation and Compatibility

Thanks to the open source of Swift, developers now could write cross platform 
programs with the same language. And I believe the command line software would be 
the next great platform for Swift. Colorful and well organized output always 
helps us to understand what happens. It is really a necessary utility to create 
wonderful software. 

`Rainbow` should work well in both OS X and Linux terminals. It is smart enough 
to check whether the output is connected to a valid text terminal or not, to 
decide the log should be modified or not. This could be useful when you want to
 send your log to a file instead to console.

Although `Rainbow` is first designed for console output in terminals, you could 
use it in Xcode with [XcodeColors](https://github.com/robbiehanson/XcodeColors) 
plugin installed too. It will enable color output for better debugging 
experience in Xcode.

> Please notice, after Xcode 8, third party plugins in bundle (like XcodeColors) is not 
supported anymore. [See this](https://github.com/alcatraz/Alcatraz/issues/475).

## Install

Rainbow 3.x supports from Swift 4. If you need to use Rainbow in Swift 3, use Rainbow 2.1 instead.

### Swift Package Manager

If you are developing a cross platform software in Swift, 
[Swift Package Manager](https://github.com/apple/swift-package-manager) might 
be your choice for package management. Just add the url of this repo to your 
`Package.swift` file as a dependency:

```swift
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "YourAwesomeSoftware",
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0")
    ]
)
```

Then run `swift build` whenever you get prepared.

You could know more information on how to use Swift Package Manager
 in Apple's [official page](https://swift.org/package-manager/).

### CocoaPods

Add the `RainbowSwift` pod to your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'RainbowSwift', '~> 3.0'
```

And you need to import `RainbowSwift` instead of `Rainbow` if you install it from CocoaPods.

```swift
// import Rainbow
import RainbowSwift

print("Hello CocoaPods".red)
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency 
manager for Cocoa application.

To integrate `Rainbow` with Carthage, add this to your `Cartfile`:

```ruby
github "onevcat/Rainbow" ~> 3.0
```

Run `carthage update` to build the framework and drag the built 
`Rainbow.framework` into your Xcode project (as well as embed it in your target 
    if necessary).

## Contact

Follow and contact me on [Twitter](http://twitter.com/onevcat) or 
[Sina Weibo](http://weibo.com/onevcat). If you find an issue, 
just [open a ticket](https://github.com/onevcat/Rainbow/issues/new) on it. Pull 
requests are warmly welcome as well.

## License

Rainbow is released under the MIT license. See LICENSE for details.
