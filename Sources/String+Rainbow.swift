//
//  String+Rainbow.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/23.
//
//  Copyright (c) 2018 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

// MARK: - Worker methods
extension String {

    /// Applies a named text color to current string.
    /// - Parameter color: The color to apply.
    /// - Returns: The colorized string based on current content.
    public func applyingColor(_ color: NamedColor) -> String {
        return applyingColor(.named(color))
    }

    /// Applies a text color to current string.
    /// - Parameter color: The color to apply.
    /// - Returns: The colorized string based on current content.
    public func applyingColor(_ color: ColorType) -> String {
        return applyingCodes(color)
    }

    /// Removes a color from current string.
    /// - Note: This method will return the string itself if there is no color component in it.
    ///         Otherwise, a string without color component will be returned and other components will remain untouched.
    /// - Returns: A string without color.
    public func removingColor() -> String {
        return removing(\.color)
    }

    /// Applies a named background color to current string.
    /// - Parameter color: The background color to apply.
    /// - Returns: The background colorized string based on current content.
    public func applyingBackgroundColor(_ color: NamedBackgroundColor) -> String {
        return applyingBackgroundColor(.named(color))
    }

    /// Applies a background color to current string.
    /// - Parameter color: The background color to apply.
    /// - Returns: The background colorized string based on current content.
    public func applyingBackgroundColor(_ color: BackgroundColorType) -> String {
        return applyingCodes(color)
    }

    /// Removes a background color from current string.
    /// - Note: This method will return the string itself if there is no background color component in it.
    ///         Otherwise, a string without background color component will be returned and other components will
    ///         remain untouched.
    /// - Returns: A string without background.
    public func removingBackgroundColor() -> String {
        return removing(\.backgroundColor)
    }

    /// Applies a style to current string.
    /// - Parameter style: The style to apply.
    /// - Returns: A string with specified style applied.
    public func applyingStyle(_ style: Style) -> String {
        return applyingCodes(style)
    }

    /// Removes a style from current string.
    /// - Parameter style: The style to remove.
    /// - Returns: A string with specified style removed.
    public func removingStyle(_ style: Style) -> String {
        return removing(\.styles, value: style)
    }

    /// Removes all styles from current string.
    /// - Note: This method will return the string itself if there is no style components in it.
    ///         Otherwise, a string without style components will be returned and other color components will remain untouched.
    /// - Returns: A string without style components.
    public func removingAllStyles() -> String {
        return removing(\.styles)
    }
    
    /// Applies a series of modes to the string.
    /// - Parameter codes: Component mode code to apply to the string.
    /// - Returns: A string with specified modes applied.
    public func applyingCodes(_ codes: ModeCode...) -> String {
        
        guard Rainbow.enabled else {
            return self
        }

        var entry = ConsoleEntryParser(text: self).parse()

        let input = ConsoleCodesParser().parse(modeCodes: codes.flatMap { $0.value } )
        if entry.segments.count == 1 { // If there is only 1 segment, overwrite the current setting
            entry.segments[0].update(with: input, overwriteColor: true)
        } else {
            entry.segments = entry.segments.map {
                var s = $0
                s.update(with: input, overwriteColor: false)
                return s
            }
        }
        
        if codes.isEmpty {
            return self
        } else {
            return Rainbow.generateString(for: entry)
        }
    }

    public func removing<T>(_ keyPath: WritableKeyPath<Rainbow.Segment, T?>) -> String {
        guard Rainbow.enabled else {
            return self
        }

        var entry = ConsoleEntryParser(text: self).parse()
        entry.segments = entry.segments.map {
            var s = $0
            s[keyPath: keyPath] = nil
            return s
        }

        return Rainbow.generateString(for: entry)
    }

    public func removing<E>(
        _ keyPath: WritableKeyPath<Rainbow.Segment, Array<E>?>, value: E
    ) -> String where E: Equatable {
        guard Rainbow.enabled else {
            return self
        }

        var entry = ConsoleEntryParser(text: self).parse()
        entry.segments = entry.segments.map {
            var s = $0
            if let v = s[keyPath: keyPath] {
                s[keyPath: keyPath] = v.filter { value != $0 }
            }

            return s
        }

        return Rainbow.generateString(for: entry)
    }
}

// MARK: - Colors Shorthand
extension String {
    /// String with black text.
    public var black: String { return applyingColor(.black) }
    /// String with red text.
    public var red: String { return applyingColor(.red) }
    /// String with green text.
    public var green: String { return applyingColor(.green) }
    /// String with yellow text.
    public var yellow: String { return applyingColor(.yellow) }
    /// String with blue text.
    public var blue: String { return applyingColor(.blue) }
    /// String with magenta text.
    public var magenta: String { return applyingColor(.magenta) }
    /// String with cyan text.
    public var cyan: String { return applyingColor(.cyan) }
    /// String with white text.
    public var white: String { return applyingColor(.white) }
    /// String with light black text. Generally speaking, it means dark grey in some consoles.
    public var lightBlack: String { return applyingColor(.lightBlack) }
    /// String with light red text.
    public var lightRed: String { return applyingColor(.lightRed) }
    /// String with light green text.
    public var lightGreen: String { return applyingColor(.lightGreen) }
    /// String with light yellow text.
    public var lightYellow: String { return applyingColor(.lightYellow) }
    /// String with light blue text.
    public var lightBlue: String { return applyingColor(.lightBlue) }
    /// String with light magenta text.
    public var lightMagenta: String { return applyingColor(.lightMagenta) }
    /// String with light cyan text.
    public var lightCyan: String { return applyingColor(.lightCyan) }
    /// String with light white text. Generally speaking, it means light grey in some consoles.
    public var lightWhite: String { return applyingColor(.lightWhite) }
    /// String with an ANSI 256 8-bit color applied.
    public func bit8(_ color: UInt8) -> String { return applyingColor(.bit8(color)) }
    /// String with an ANSI 256 24-bit color applied. This is not supported by all terminals.
    public func bit24(_ color: RGB) -> String { return applyingColor(.bit24(color)) }
    /// String with an ANSI 256 24-bit color applied, with R, G, B component. This is not supported by all terminals.
    public func bit24(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> String { return bit24((red, green, blue)) }

    /// String with a Hex color applied to the text. The exact color which will be used is determined by the `target`.
    ///
    /// - Parameters:
    ///   - color: The Hex formatted color string. Hex-3 and Hex-6 are supported, with or without a leading sharp
    ///            character. For example, "#333", "#FF00FF", "a3a3a3" are valid, while "0xffffff", "#abcd", "kk00aa"
    ///            are not.
    ///   - target: The conversion target of this color. If `target` is `.bit8Approximated`, an approximated 8-bit
    ///             color to the Hex color will be used; If `.bit24`, a 24-bit color is used without approximation.
    ///             However, keep in mind that the support of 24-bit depends on the terminal and it is not widely used.
    ///             Default is `.bit8Approximated`.
    /// - Returns: The formatted string if the `color` represents a valid color. Otherwise, `self`.
    public func hex(_ color: String, to target: HexColorTarget = .bit8Approximated) -> String {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingColor(converter.convert(to: target))
    }

    /// String with a Hex color applied to the text. The exact color which will be used is determined by the `target`.
    ///
    /// - Parameters:
    ///   - color: The color value in Hex format. Usually it is a hex number like `0xFF0000`. Alpha channel is not
    ///            supported, so any value out the range `0x000000 ... 0xFFFFFF` is invalid.
    ///   - target: The conversion target of this color. If `target` is `.bit8Approximated`, an approximated 8-bit
    ///             color to the Hex color will be used; If `.bit24`, a 24-bit color is used without approximation.
    ///             However, keep in mind that the support of 24-bit depends on the terminal and it is not widely used.
    ///             Default is `.bit8Approximated`.
    /// - Returns: The formatted string if the `color` represents a valid color. Otherwise, `self`.
    public func hex(_ color: UInt32, to target: HexColorTarget = .bit8Approximated) -> String {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingColor(converter.convert(to: target))
    }
}

// MARK: - Background Colors Shorthand
extension String {
    /// String with black background.
    public var onBlack: String { return applyingBackgroundColor(.black) }
    /// String with red background.
    public var onRed: String { return applyingBackgroundColor(.red) }
    /// String with green background.
    public var onGreen: String { return applyingBackgroundColor(.green) }
    /// String with yellow background.
    public var onYellow: String { return applyingBackgroundColor(.yellow) }
    /// String with blue background.
    public var onBlue: String { return applyingBackgroundColor(.blue) }
    /// String with magenta background.
    public var onMagenta: String { return applyingBackgroundColor(.magenta) }
    /// String with cyan background.
    public var onCyan: String { return applyingBackgroundColor(.cyan) }
    /// String with white background.
    public var onWhite: String { return applyingBackgroundColor(.white) }
    /// String with light black background. Generally speaking, it means dark grey in some consoles.
    public var onLightBlack: String { return applyingBackgroundColor(.lightBlack) }
    /// String with light red background.
    public var onLightRed: String { return applyingBackgroundColor(.lightRed) }
    /// String with light green background.
    public var onLightGreen: String { return applyingBackgroundColor(.lightGreen) }
    /// String with light yellow background.
    public var onLightYellow: String { return applyingBackgroundColor(.lightYellow) }
    /// String with light blue background.
    public var onLightBlue: String { return applyingBackgroundColor(.lightBlue) }
    /// String with light magenta background.
    public var onLightMagenta: String { return applyingBackgroundColor(.lightMagenta) }
    /// String with light cyan background.
    public var onLightCyan: String { return applyingBackgroundColor(.lightCyan) }
    /// String with light white background. Generally speaking, it means light grey in some consoles.
    public var onLightWhite: String { return applyingBackgroundColor(.lightWhite) }

    /// String with an ANSI 256 8-bit background color applied.
    public func onBit8(_ color: UInt8) -> String { return applyingBackgroundColor(.bit8(color)) }
    /// String with an ANSI 256 24-bit background color applied. This is not supported by all terminals.
    public func onBit24(_ color: RGB) -> String { return applyingBackgroundColor(.bit24(color)) }
    /// String with an ANSI 256 24-bit background color applied, with R, G, B component. This is not supported by all terminals.
    public func onBit24(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> String { return onBit24((red, green, blue)) }

    /// String with a Hex color applied to the background. The exact color which will be used is determined by the `target`.
    ///
    /// - Parameters:
    ///   - color: The Hex formatted color string. Hex-3 and Hex-6 are supported, with or without a leading sharp
    ///            character. For example, "#333", "#FF00FF", "a3a3a3" are valid, while "0xffffff", "#abcd", "kk00aa"
    ///            are not.
    ///   - target: The conversion target of this color. If `target` is `.bit8Approximated`, an approximated 8-bit
    ///             color to the Hex color will be used; If `.bit24`, a 24-bit color is used without approximation.
    ///             However, keep in mind that the support of 24-bit depends on the terminal and it is not widely used.
    ///             Default is `.bit8Approximated`.
    /// - Returns: The formatted string if the `color` represents a valid color. Otherwise, `self`.
    public func onHex(_ color: String, to target: HexColorTarget = .bit8Approximated) -> String {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingBackgroundColor(converter.convert(to: target))
    }

    /// String with a Hex color applied to the background. The exact color which will be used is determined by the `target`.
    ///
    /// - Parameters:
    ///   - color: The color value in Hex format. Usually it is a hex number like `0xFF0000`. Alpha channel is not
    ///            supported, so any value out the range `0x000000 ... 0xFFFFFF` is invalid.
    ///   - target: The conversion target of this color. If `target` is `.bit8Approximated`, an approximated 8-bit
    ///             color to the Hex color will be used; If `.bit24`, a 24-bit color is used without approximation.
    ///             However, keep in mind that the support of 24-bit depends on the terminal and it is not widely used.
    ///             Default is `.bit8Approximated`.
    /// - Returns: The formatted string if the `color` represents a valid color. Otherwise, `self`.
    public func onHex(_ color: UInt32, to target: HexColorTarget = .bit8Approximated) -> String {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingBackgroundColor(converter.convert(to: target))
    }
}

// MARK: - Styles Shorthand
extension String {
    /// String with bold style.
    public var bold: String { return applyingStyle(.bold) }
    /// String with dim style. This is not widely supported in all terminals. Use it carefully.
    public var dim: String { return applyingStyle(.dim) }
    /// String with italic style. This depends on whether an italic existing for the font family of terminals.
    public var italic: String { return applyingStyle(.italic) }
    /// String with underline style.
    public var underline: String { return applyingStyle(.underline) }
    /// String with blink style. This is not widely supported in all terminals, or need additional setting. Use it carefully.
    public var blink: String { return applyingStyle(.blink) }
    /// String with text color and background color swapped.
    public var swap: String { return applyingStyle(.swap) }
}

// MARK: - Clear Modes Shorthand
extension String {
    /// Clear color component from string.
    public var clearColor: String { return removingColor() }
    /// Clear background color component from string.
    public var clearBackgroundColor: String { return removingBackgroundColor() }
    /// Clear styles components from string.
    public var clearStyles: String { return removingAllStyles() }
}

extension String {
    /// Get the raw string of current Rainbow styled string. O(n)
    public var raw: String {
        return Rainbow.extractEntry(for: self).plainText
    }
}
