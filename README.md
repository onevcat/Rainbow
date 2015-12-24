![Rainbow](https://raw.githubusercontent.com/onevcat/Rainbow/assets/rainbow.png)

**`Rainbow` is a framework under developing, It is not released now. Do not use it yet.**

`Rainbow` adds methods to set text color, background color and style for Swift 
console and command line output, for both OS X and Linux. It is also compatible 
with [XcodeColors](https://github.com/robbiehanson/XcodeColors), so you could 
use it in your Xcode to colorize the debugger output as well.

## Usage

Nifty way, using the `String` extension:

```swift
import Rainbow

print("Red text".red)
print("Yellow background".onYellow)
print("Light green text on white background".lightGreen.onWhite)

print("Underline".underline)
print("Cyan with bold and blinking".cyan.bold.blink)

print("Plain text".red.onYellow.bold.clearColor.clearBackgroundColor.clearStyles)
```

You can also use the more verbose way if you need:

```swift
import Rainbow
let output = "The quick brown fox jumps over the lazy dog"
                .stringByApplying([Color.Red, BackgroundColor.Yellow, Style.Bold])
print(output) // Red text on yellow, bold of course :)
```

## Motivation and Compatibility

Thanks to the open source of Swift, developers now could write cross platform 
programs with the same language. And I believe the command line tool would be 
the next great platform for Swift. Colorful and well organized output helps us 
to understand what happens and it could be a necessary utility to create 
wonderful software. 

`Rainbow` should work well in both OS X and Linux terminals. It will also check 
whether the output is a valid text terminal or not, to decide which to log. 
It could be useful when you want to log to a file instead to terminals.

Although `Rainbow` is first designed for console output in terminals, you could 
use it in Xcode with [XcodeColors](https://github.com/robbiehanson/XcodeColors) 
plugin installed too. It will enable color output for better debugging experience.

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

Not supported yet.

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

## Contact

Follow and contact me on [Twitter](http://twitter.com/onevcat) or 
[Sina Weibo](http://weibo.com/onevcat). If you find an issue, 
just [open a ticket](https://github.com/onevcat/Rainbow/issues/new) on it. Pull 
requests are warmly welcome as well.

## License

Rainbow is released under the MIT license. See LICENSE for details.
