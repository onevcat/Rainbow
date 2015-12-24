![Rainbow](https://raw.githubusercontent.com/onevcat/Rainbow/assets/rainbow.png)

`Rainbow` adds text color, background color and style for console and command 
line output in Swift. It is born for cross platform software logging 
in terminals, working in both Apple's platforms and Linux. Meanwhile, it is also 
compatible with [XcodeColors](https://github.com/robbiehanson/XcodeColors), 
which lets you colorize the Xcode debugger output as well when developing an app.

## Usage

Nifty way, using the `String` extension, and print the colorized string:

```swift
import Rainbow

print("Red text".red)
print("Yellow background".onYellow)
print("Light green text on white background".lightGreen.onWhite)

print("Underline".underline)
print("Cyan with bold and blinking".cyan.bold.blink)

print("Plain text".red.onYellow.bold.clearColor.clearBackgroundColor.clearStyles)
```

You can also use the more verbose way if you want:

```swift
import Rainbow
let output = "The quick brown fox jumps over the lazy dog"
                .stringByApplying(Color.Red, BackgroundColor.Yellow, Style.Bold)
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

## Install

### Swift Package Manager

If you are developing a cross platform software in Swift, 
[Swift Package Manager](https://github.com/apple/swift-package-manager) might 
be your choice for package management. Just add the url of this repo to your 
`Package.swift` file as a dependency:

```swift
import PackageDescription

let package = Package(
    name: "YourAwesomeSoftware",
    dependencies: [
        .Package(url: "https://github.com/onevcat/Rainbow",
                 majorVersion: 1),
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

pod 'RainbowSwift', '~> 1.0'
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
github "onevcat/Rainbow" ~> 1.0
```

Run `carthage update` to build the framework and drag the built 
`Rainbow.framework` into your Xcode project (as well as embed it in your target 
    if necessary).

## Questions

If you are using `Rainbow` with `XcodeColors` and developing iOS/watch/tv apps, sometimes 
the environment variables are not passed to the device, which causes the logs not 
colorized correctly in Xcode console. To solve it, you need to specify the 
`["XcodeColors": "YES"]` to the scheme setting. 
See [here](https://github.com/CocoaLumberjack/CocoaLumberjack/blob/master/Documentation/XcodeColors.md#xcodecolors-and-ios) for more.

## Contact

Follow and contact me on [Twitter](http://twitter.com/onevcat) or 
[Sina Weibo](http://weibo.com/onevcat). If you find an issue, 
just [open a ticket](https://github.com/onevcat/Rainbow/issues/new) on it. Pull 
requests are warmly welcome as well.

## License

Rainbow is released under the MIT license. See LICENSE for details.
