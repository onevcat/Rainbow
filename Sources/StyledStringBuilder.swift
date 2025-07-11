//
//  StyledStringBuilder.swift
//  Rainbow
//
//  Created by Performance Optimization on 2025-07-11.
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

import Foundation

/// High-performance string builder for Rainbow styling (available in v4.2.0+)
/// Uses lazy evaluation to minimize string copying in chained calls
public struct StyledStringBuilder {
    private let text: String
    private var color: ColorType?
    private var backgroundColor: BackgroundColorType?
    private var styles: [Style] = []
    
    init(_ text: String) {
        self.text = text
    }
    
    private init(text: String, color: ColorType?, backgroundColor: BackgroundColorType?, styles: [Style]) {
        self.text = text
        self.color = color
        self.backgroundColor = backgroundColor
        self.styles = styles
    }
    
    // MARK: - Color Methods
    
    public func applyingColor(_ color: ColorType) -> StyledStringBuilder {
        return StyledStringBuilder(text: text, color: color, backgroundColor: backgroundColor, styles: styles)
    }
    
    public func applyingBackgroundColor(_ backgroundColor: BackgroundColorType) -> StyledStringBuilder {
        return StyledStringBuilder(text: text, color: color, backgroundColor: backgroundColor, styles: styles)
    }
    
    public func applyingStyle(_ style: Style) -> StyledStringBuilder {
        var newStyles = styles
        newStyles.append(style)
        return StyledStringBuilder(text: text, color: color, backgroundColor: backgroundColor, styles: newStyles)
    }
    
    // MARK: - Convenience Color Properties
    
    public var black: StyledStringBuilder { return applyingColor(.named(.black)) }
    public var red: StyledStringBuilder { return applyingColor(.named(.red)) }
    public var green: StyledStringBuilder { return applyingColor(.named(.green)) }
    public var yellow: StyledStringBuilder { return applyingColor(.named(.yellow)) }
    public var blue: StyledStringBuilder { return applyingColor(.named(.blue)) }
    public var magenta: StyledStringBuilder { return applyingColor(.named(.magenta)) }
    public var cyan: StyledStringBuilder { return applyingColor(.named(.cyan)) }
    public var white: StyledStringBuilder { return applyingColor(.named(.white)) }
    public var lightBlack: StyledStringBuilder { return applyingColor(.named(.lightBlack)) }
    public var lightRed: StyledStringBuilder { return applyingColor(.named(.lightRed)) }
    public var lightGreen: StyledStringBuilder { return applyingColor(.named(.lightGreen)) }
    public var lightYellow: StyledStringBuilder { return applyingColor(.named(.lightYellow)) }
    public var lightBlue: StyledStringBuilder { return applyingColor(.named(.lightBlue)) }
    public var lightMagenta: StyledStringBuilder { return applyingColor(.named(.lightMagenta)) }
    public var lightCyan: StyledStringBuilder { return applyingColor(.named(.lightCyan)) }
    public var lightWhite: StyledStringBuilder { return applyingColor(.named(.lightWhite)) }
    
    // MARK: - Convenience Background Color Properties
    
    public var onBlack: StyledStringBuilder { return applyingBackgroundColor(.named(.black)) }
    public var onRed: StyledStringBuilder { return applyingBackgroundColor(.named(.red)) }
    public var onGreen: StyledStringBuilder { return applyingBackgroundColor(.named(.green)) }
    public var onYellow: StyledStringBuilder { return applyingBackgroundColor(.named(.yellow)) }
    public var onBlue: StyledStringBuilder { return applyingBackgroundColor(.named(.blue)) }
    public var onMagenta: StyledStringBuilder { return applyingBackgroundColor(.named(.magenta)) }
    public var onCyan: StyledStringBuilder { return applyingBackgroundColor(.named(.cyan)) }
    public var onWhite: StyledStringBuilder { return applyingBackgroundColor(.named(.white)) }
    public var onLightBlack: StyledStringBuilder { return applyingBackgroundColor(.named(.lightBlack)) }
    public var onLightRed: StyledStringBuilder { return applyingBackgroundColor(.named(.lightRed)) }
    public var onLightGreen: StyledStringBuilder { return applyingBackgroundColor(.named(.lightGreen)) }
    public var onLightYellow: StyledStringBuilder { return applyingBackgroundColor(.named(.lightYellow)) }
    public var onLightBlue: StyledStringBuilder { return applyingBackgroundColor(.named(.lightBlue)) }
    public var onLightMagenta: StyledStringBuilder { return applyingBackgroundColor(.named(.lightMagenta)) }
    public var onLightCyan: StyledStringBuilder { return applyingBackgroundColor(.named(.lightCyan)) }
    public var onLightWhite: StyledStringBuilder { return applyingBackgroundColor(.named(.lightWhite)) }
    
    // MARK: - Convenience Style Properties
    
    public var bold: StyledStringBuilder { return applyingStyle(.bold) }
    public var dim: StyledStringBuilder { return applyingStyle(.dim) }
    public var italic: StyledStringBuilder { return applyingStyle(.italic) }
    public var underline: StyledStringBuilder { return applyingStyle(.underline) }
    public var blink: StyledStringBuilder { return applyingStyle(.blink) }
    public var swap: StyledStringBuilder { return applyingStyle(.swap) }
    
    // MARK: - Advanced Color Methods
    
    public func bit8(_ color: UInt8) -> StyledStringBuilder {
        return applyingColor(.bit8(color))
    }
    
    public func bit24(_ color: RGB) -> StyledStringBuilder {
        return applyingColor(.bit24(color))
    }
    
    public func bit24(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> StyledStringBuilder {
        return applyingColor(.bit24((red, green, blue)))
    }
    
    public func hex(_ color: String, to target: HexColorTarget = .bit8Approximated) -> StyledStringBuilder {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingColor(converter.convert(to: target))
    }
    
    public func hex(_ color: UInt32, to target: HexColorTarget = .bit8Approximated) -> StyledStringBuilder {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingColor(converter.convert(to: target))
    }
    
    public func onBit8(_ color: UInt8) -> StyledStringBuilder {
        return applyingBackgroundColor(.bit8(color))
    }
    
    public func onBit24(_ color: RGB) -> StyledStringBuilder {
        return applyingBackgroundColor(.bit24(color))
    }
    
    public func onBit24(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> StyledStringBuilder {
        return applyingBackgroundColor(.bit24((red, green, blue)))
    }
    
    public func onHex(_ color: String, to target: HexColorTarget = .bit8Approximated) -> StyledStringBuilder {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingBackgroundColor(converter.convert(to: target))
    }
    
    public func onHex(_ color: UInt32, to target: HexColorTarget = .bit8Approximated) -> StyledStringBuilder {
        guard let converter = ColorApproximation(color: color) else { return self }
        return applyingBackgroundColor(converter.convert(to: target))
    }
    
    // MARK: - Batch Operations
    
    public func applyingMultipleStyles(_ styles: [Style]) -> StyledStringBuilder {
        var newStyles = self.styles
        newStyles.append(contentsOf: styles)
        return StyledStringBuilder(text: text, color: color, backgroundColor: backgroundColor, styles: newStyles)
    }
    
    public func applyingAll(color: ColorType?, backgroundColor: BackgroundColorType?, styles: [Style]) -> StyledStringBuilder {
        let finalColor = color ?? self.color
        let finalBackgroundColor = backgroundColor ?? self.backgroundColor
        var finalStyles = self.styles
        finalStyles.append(contentsOf: styles)
        return StyledStringBuilder(text: text, color: finalColor, backgroundColor: finalBackgroundColor, styles: finalStyles)
    }
    
    // MARK: - Output Generation
    
    /// Generate the final styled string
    /// This is where the actual string processing happens (lazy evaluation)
    public func build() -> String {
        guard Rainbow.enabled else { return text }
        
        let segment = Rainbow.Segment(
            text: text,
            color: color,
            backgroundColor: backgroundColor,
            styles: styles.isEmpty ? nil : styles
        )
        
        let entry = Rainbow.Entry(segments: [segment])
        return Rainbow.generateString(for: entry)
    }
    
    /// Get the plain text without any styling
    public var plainText: String {
        return text
    }
}

// MARK: - String Extension for Builder Pattern
extension String {
    /// Create a StyledStringBuilder for high-performance chaining (available in v4.2.0+)
    public var styled: StyledStringBuilder {
        return StyledStringBuilder(self)
    }
}

// MARK: - CustomStringConvertible
extension StyledStringBuilder: CustomStringConvertible {
    public var description: String {
        return build()
    }
}

// MARK: - Equatable
extension StyledStringBuilder: Equatable {
    public static func == (lhs: StyledStringBuilder, rhs: StyledStringBuilder) -> Bool {
        return lhs.text == rhs.text &&
               lhs.color == rhs.color &&
               lhs.backgroundColor == rhs.backgroundColor &&
               lhs.styles == rhs.styles
    }
}