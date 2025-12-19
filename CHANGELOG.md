# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- Optimized `Entry.plainText` concatenation for better performance. ([#86](https://github.com/onevcat/Rainbow/pull/86))

## [4.2.0] - 2025-07-26

### Added
- High-performance `StyledStringBuilder` API for efficient string chaining. ([#78](https://github.com/onevcat/Rainbow/pull/78))
- HSL (Hue, Saturation, Lightness) color support with RGB conversion. ([#80](https://github.com/onevcat/Rainbow/pull/80))
- Strikethrough style support with ANSI escape sequences. ([#82](https://github.com/onevcat/Rainbow/pull/82))
- Conditional styling feature allowing styles based on conditions. ([#81](https://github.com/onevcat/Rainbow/pull/81))
- Batch operations API for better performance when applying multiple styles. ([#78](https://github.com/onevcat/Rainbow/pull/78))
- Comprehensive performance testing framework. ([#78](https://github.com/onevcat/Rainbow/pull/78))
- Performance optimization guide documentation. ([#78](https://github.com/onevcat/Rainbow/pull/78))

### Fixed
- Memory efficiency improvements in `StringGenerator`. ([#78](https://github.com/onevcat/Rainbow/pull/78))
- Performance optimizations for chained style operations. ([#78](https://github.com/onevcat/Rainbow/pull/78))
- Improved test coverage with comprehensive edge case tests. ([#79](https://github.com/onevcat/Rainbow/pull/79))

## [4.1.0] - 2025-01-08

### Added
- Support `FORCE_COLOR` environment to enable color in a nested env. ([#76](https://github.com/onevcat/Rainbow/pull/76))

### Fixed
- Environment value checking requires non-zero and non-empty value to represent "set" status. ([#76](https://github.com/onevcat/Rainbow/pull/76))
- Modernize the project to follow the Xcode settings in current days. ([#76](https://github.com/onevcat/Rainbow/pull/76))

## [4.0.1] - 2021-09-29

### Fixed
- Every segment resets its style to prevent unexpected spreading. ([#62](https://github.com/onevcat/Rainbow/pull/62))

## [4.0.0] - 2021-03-09

### Added
- [ANSI 256-color](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit) support. Use `.bit8` or `.onBit8` to apply a 256-color to a string. ([#49](https://github.com/onevcat/Rainbow/pull/49))
- Hex colors approximation support. Use `.hex` or `.onHex` to apply an 8-bit color as the Hex color approximated to a string. ([#56](https://github.com/onevcat/Rainbow/pull/56))
- Add support for colorizing nested strings. ([#51](https://github.com/onevcat/Rainbow/pull/51))
- Add the light version of background named colors. ([#50](https://github.com/onevcat/Rainbow/pull/50))
- Add the strikethrough style. ([#55](https://github.com/onevcat/Rainbow/pull/55))
- Support color conversion between text color and its corresponding background color. Vice versa. ([#54](https://github.com/onevcat/Rainbow/pull/54))

### Removed
- The Xcode Color console output target is removed. It does not make sense anymore unless there is a new way to log color strings to the Xcode console. ([#47](https://github.com/onevcat/Rainbow/pull/47))

## [3.2.0] - 2020-10-05

### Added
- Support for compiling and using on Windows. ([#40](https://github.com/onevcat/Rainbow/pull/40))

## [3.0.0] - 2017-11-26

### Changed
- Swift 4 support. ([#17](https://github.com/onevcat/Rainbow/pull/17))

## [2.1.0] - 2017-08-03

### Added
- Expose `Rainbow.extractModes` as public. ([#16](https://github.com/onevcat/Rainbow/pull/16))

## [2.0.1] - 2016-09-30

### Added
- Support for Linux. ([#9](https://github.com/onevcat/Rainbow/pull/9))

## [2.0.0] - 2016-09-25

### Changed
- Swift 3 compatibility. ([#5](https://github.com/onevcat/Rainbow/pull/5))

## [1.1.0] - 2016-03-24

### Changed
- Support for Swift 2.2. ([#2](https://github.com/onevcat/Rainbow/pull/2))

[Unreleased]: https://github.com/onevcat/Rainbow/compare/4.2.0...HEAD
[4.2.0]: https://github.com/onevcat/Rainbow/releases/tag/4.2.0
[4.1.0]: https://github.com/onevcat/Rainbow/releases/tag/4.1.0
[4.0.1]: https://github.com/onevcat/Rainbow/releases/tag/4.0.1
[4.0.0]: https://github.com/onevcat/Rainbow/releases/tag/4.0.0
[3.2.0]: https://github.com/onevcat/Rainbow/releases/tag/3.2.0
[3.0.0]: https://github.com/onevcat/Rainbow/releases/tag/3.0.0
[2.1.0]: https://github.com/onevcat/Rainbow/releases/tag/2.1.0
[2.0.1]: https://github.com/onevcat/Rainbow/releases/tag/2.0.1
[2.0.0]: https://github.com/onevcat/Rainbow/releases/tag/2.0.0
[1.1.0]: https://github.com/onevcat/Rainbow/releases/tag/1.1.0
