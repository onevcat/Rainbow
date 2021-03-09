![Rainbow](https://raw.githubusercontent.com/onevcat/Rainbow/assets/rainbow.png)

<p align="center">
<a href="https://github.com/onevcat/Rainbow/actions/workflows/ci.yaml"><img src="https://github.com/onevcat/Rainbow/actions/workflows/ci.yaml/badge.svg"></a>
<a href="https://codecov.io/github/onevcat/Rainbow?branch=master"><img src="https://img.shields.io/codecov/c/github/onevcat/Rainbow.svg"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-ready-orange.svg"></a>
<a href="http://cocoadocs.org/docsets/RainbowSwift"><img src="https://img.shields.io/badge/platform-osx%7Clinux%7Cwindows-lightgrey.svg"></a>
<a href="https://raw.githubusercontent.com/onevcat/Rainbow/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/RainbowSwift.svg?style=flat"></a>
</p>

`Rainbow` adds text color, background color and style for console and command 
line output in Swift. It is born for cross-platform software logging 
in terminals, working in both Apple's platforms and Linux.

## Basic Usage

Nifty way, using the `String` extension, and print the colorized string.

### Named Color & Style

```swift
import Rainbow

print("Red text".red)
print("Blue background".onBlue)
print("Light green text on white background".lightGreen.onWhite)

print("Underline".underline)
print("Cyan with bold and blinking".cyan.bold.blink)

print("Plain text".red.onYellow.bold.clearColor.clearBackgroundColor.clearStyles)
```

It gives you something like this:

![](https://user-images.githubusercontent.com/1019875/110485682-3fdfa700-812f-11eb-83f7-ca79795a0514.png)

## Installation

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
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(
            name: "MyApp",
            dependencies: ["Rainbow"]
        )
    ]
)
```

Then run `swift build` whenever you get prepared.

You could know more information on how to use Swift Package Manager in Apple's [official page](https://swift.org/package-manager/).

## Other Usage

### String Interpolation & Nested

Swift string interpolation is supported. Define the color for part of the string. Or even create nested colorful strings. The inner color style will be kept:

```swift
print("接天莲叶\("无穷碧".green)，映日荷花\("别样红".red)")
print("\("两只黄鹂".yellow)鸣翠柳，一行白鹭\("上青天".lightBlue)。".lightGreen.underline)
```

![](https://user-images.githubusercontent.com/1019875/110489426-bcc05000-8132-11eb-8b13-caab01faa416.png)

### ANSI 256-Color Mode

[8-bit color](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit) is fully supported, for both text color and background color:

```swift
print("停车坐爱\("枫林晚".bit8(31))，\("霜叶".bit8(160))红于\("二月花".bit8(198))。")
print("\("一道残阳".bit8(202))铺水中，\("半江瑟瑟".bit8(30).onBit8(226))半江红。")
```

![](https://user-images.githubusercontent.com/1019875/110490505-bda5b180-8133-11eb-97b2-f376d62e07de.png)

### Hex Colors (approximated)

It also accepts a Hex color. Rainbow tries to convert it to a most approximate `.bit8` color:

```swift
print("黑云压城\("城欲摧".hex("#666"))，甲光向日\("金鳞开".hex("000000").onHex("#E6B422"))。")
print("日出江花\("红胜火".hex(0xd11a2d))，春来江水\("绿如蓝".hex(0x10aec2))")
```

![](https://user-images.githubusercontent.com/1019875/110492277-60aafb00-8135-11eb-9aba-e25658f5bc06.png)

> Valid format: `"FFF"`, `"#FFF"`, `"FFFFFF"`, `"#FFFFFF"`, `0xFFFFFF`

### True color

A few terminal emulators supports 24-bit true color. If you are sure the 24-bit colors can be displayed in your user's
terminal, Rainbow has no reason to refuse them!

```swift
print("疏影横斜\("水清浅".bit24(36,116,181))，暗香浮动\("月黄昏".bit24(254,215,26))")
print("\("春色满园".hex("#ea517f", to: .bit24))关不住，\("一枝红杏".hex("#f43e06", to: .bit24))出墙来。")
```

![](https://user-images.githubusercontent.com/1019875/110496210-9d2c2600-8138-11eb-803d-15a745ef1dfb.png)

### Output Target

By default, Rainbow should be smart enough to detect the output target, to determine if it is a tty. For example, it
automatically output plain text if written to a file:

```sh
// main.swift
print("Hello Rainbow".red)

$ .build/debug/RainbowDemo > output.txt

// output.txt
Hello Rainbow
```

This is useful for sharing the same code for logging to console and to a log file.

You can manually change this behavior by either:

- Set the `Rainbow.outputTarget` yourself.
- Pass a `"NO_COLOR"` environment value when executing your app.
- Or set the `Rainbow.enabled` to disable it.


### Verbose Way

You can also use the more verbose way if you want:

```swift
import Rainbow
let output = "The quick brown fox jumps over the lazy dog"
                .applyingCodes(Color.red, BackgroundColor.yellow, Style.bold)
print(output) // Red text on yellow, bold of course :)
```

Or even construct everything from scratch:

```swift
let entry = Rainbow.Entry(
    segments: [
        .init(text: "Hello ", color: .named(.magenta)),
        .init(text: "Rainbow", color: .bit8(214), backgroundColor: .named(.lightBlue), styles: [.underline]),
    ]
)
print(Rainbow.generateString(for: entry))
```

Please remember, the string extensions (such as `"Hello".red`) is `O(n)`. So if you are handling a huge string or very 
complex nesting, there might be a performance issue or hard to make things in stream. The manual way is a rescue for these
cases.


## Motivation and Compatibility

Thanks to the open source of Swift, developers now could write cross platform 
programs with the same language. And I believe the command line software would be 
the next great platform for Swift. Colorful and well-organized output always 
helps us to understand what happens. It is really a necessary utility to create 
wonderful software. 

`Rainbow` should work well in both OS X and Linux terminals. It is smart enough 
to check whether the output is connected to a valid text terminal or not, to 
decide the log should be modified or not. This could be useful when you want to
 send your log to a file instead to console.


## Contact

Follow and contact me on [Twitter](http://twitter.com/onevcat) or 
[Sina Weibo](http://weibo.com/onevcat). If you find an issue, 
just [open a ticket](https://github.com/onevcat/Rainbow/issues/new) on it. Pull 
requests are warmly welcome as well.

## Backers & Sponsors

Open-source projects cannot live long without your help. If you find Kingfisher is useful, please consider supporting this
project by becoming a sponsor. Your user icon or company logo shows up [on my blog](https://onevcat.com/tabs/about/) with a link to your home page.

Become a sponsor through [GitHub Sponsors](https://github.com/sponsors/onevcat). :heart:

## License

Rainbow is released under the MIT license. See LICENSE for details.
