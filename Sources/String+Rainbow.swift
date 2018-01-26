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
    /**
     Apply a text color to current string.
     
     - parameter color: The color to apply.
     
     - returns: The colorized string based on current content.
     */
    public func applyingColor(_ color: Color) -> String {
        return applyingCodes(color)
    }
    
    /**
     Remove a color from current string.
     
     - Note: This method will return the string itself if there is no color component in it.
     Otherwise, a string without color component will be returned and other components will remain untouched..
     
     - returns: A string without color.
     */
    public func removingColor() -> String {
        guard let _ = Rainbow.extractModes(for: self).color else {
            return self
        }
        return applyingColor(.default)
    }
    
    /**
     Apply a background color to current string.
     
     - parameter color: The background color to apply.
     
     - returns: The background colorized string based on current content.
     */
    public func applyingBackgroundColor(_ color: BackgroundColor) -> String {
        return applyingCodes(color)
    }
    
    /**
     Remove a background color from current string.
     
     - Note: This method will return the string itself if there is no background color component in it.
     Otherwise, a string without background color component will be returned and other components will remain untouched.
     
     - returns: A string without color.
     */
    public func removingBackgroundColor() -> String {
        guard let _ = Rainbow.extractModes(for: self).backgroundColor else {
            return self
        }

        return applyingBackgroundColor(.default)
    }
    
    /**
     Apply a style to current string.
     
     - parameter style: The style to apply.
     
     - returns: A string with specified style applied.
     */
    public func applyingStyle(_ style: Style) -> String {
        return applyingCodes(style)
    }
    
    /**
     Remove a style from current string.
     
     - parameter style: The style to remove.
     
     - returns: A string with specified style removed.
     */
    public func removingStyle(_ style: Style) -> String {
        
        guard Rainbow.enabled else {
            return self
        }
        
        let current = Rainbow.extractModes(for: self)
        if let styles = current.styles {
            var s = styles
            var index = s.index(of: style)
            while index != nil {
                s.remove(at: index!)
                index = s.index(of: style)
            }
            return Rainbow.generateString(
                forColor: current.color,
                backgroundColor: current.backgroundColor,
                styles: s,
                text: current.text
            )
        } else {
            return self
        }
    }
    
    /**
     Remove all styles from current string.

     - Note: This method will return the string itself if there is no style components in it.
     Otherwise, a string without stlye components will be returned and other color components will remain untouched.
     
     - returns: A string without style components.
     */
    public func removingAllStyles() -> String {
        
        guard Rainbow.enabled else {
            return self
        }
        
        let current = Rainbow.extractModes(for: self)
        return Rainbow.generateString(
            forColor: current.color,
            backgroundColor: current.backgroundColor,
            styles: nil,
            text: current.text
        )
    }
    
    /**
     Apply a series of modes to the string.
     
     - parameter codes: Component mode code to apply to the string.
     
     - returns: A string with specified modes applied.
     */
    public func applyingCodes(_ codes: ModeCode...) -> String {
        
        guard Rainbow.enabled else {
            return self
        }
        
        let current = Rainbow.extractModes(for: self)
        let input = ConsoleCodesParser().parse(modeCodes: codes.map{ $0.value } )
        
        let color = input.color ?? current.color
        let backgroundColor = input.backgroundColor ?? current.backgroundColor
        var styles = [Style]()
        
        if let s = current.styles {
            styles += s
        }
        
        if let s = input.styles {
            styles += s
        }
        
        if codes.isEmpty {
            return self
        } else {
            return Rainbow.generateString(
                forColor: color,
                backgroundColor: backgroundColor,
                styles: styles.isEmpty ? nil : styles,
                text: current.text
            )
        }
    }
}

// MARK: - Colors Shorthand
extension String {
    /// String with black text.
    public var black: String { return applyingColor(.black) }
    /// String with red text.
    public var red: String { return applyingColor(.red)   }
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
}

// MARK: - Styles Shorthand
extension String {
    /// String with bold style.
    public var bold: String { return applyingStyle(.bold) }
    /// String with dim style. This is not widely supported in all terminals. Use it carefully.
    public var dim: String { return applyingStyle(.dim) }
    /// String with italic style. This depends on whether a italic existing for the font family of terminals.
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
        return Rainbow.extractModes(for: self).text
    }
}
