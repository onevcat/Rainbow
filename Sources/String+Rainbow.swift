//
//  String+Rainbow.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/23.
//
//  Copyright (c) 2015 Wei Wang <onevcat@gmail.com>
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
    public func stringByApplyingColor(color: Color) -> String {
        return stringByApplying(color)
    }
    
    /**
     Remove a color from current string.
     
     - Note: This method will return the string itself if there is no color component in it.
     Otherwise, a string without color component will be returned and other components will remain untouched..
     
     - returns: A string without color.
     */
    public func stringByRemovingColor() -> String {
        guard let _ = Rainbow.extractModesForString(self).color else {
            return self
        }
        return stringByApplyingColor(.Default)
    }
    
    /**
     Apply a background color to current string.
     
     - parameter color: The background color to apply.
     
     - returns: The background colorized string based on current content.
     */
    public func stringByApplyingBackgroundColor(color: BackgroundColor) -> String {
        return stringByApplying(color)
    }
    
    /**
     Remove a background color from current string.
     
     - Note: This method will return the string itself if there is no background color component in it.
     Otherwise, a string without background color component will be returned and other components will remain untouched.
     
     - returns: A string without color.
     */
    public func stringByRemovingBackgroundColor() -> String {
        guard let _ = Rainbow.extractModesForString(self).backgroundColor else {
            return self
        }

        return stringByApplyingBackgroundColor(.Default)
    }
    
    /**
     Apply a style to current string.
     
     - parameter style: The style to apply.
     
     - returns: A string with specified style applied.
     */
    public func stringByApplyingStyle(style: Style) -> String {
        return stringByApplying(style)
    }
    
    /**
     Remove a style from current string.
     
     - parameter style: The style to remove.
     
     - returns: A string with specified style removed.
     */
    public func stringByRemovingStyle(style: Style) -> String {
        
        guard Rainbow.enabled else {
            return self
        }
        
        let current = Rainbow.extractModesForString(self)
        if let styles = current.styles {
            var s = styles
            var index = s.indexOf(style)
            while index != nil {
                s.removeAtIndex(index!)
                index = s.indexOf(style)
            }
            return Rainbow.generateStringForColor(
                current.color,
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
    public func stringByRemovingAllStyles() -> String {
        
        guard Rainbow.enabled else {
            return self
        }
        
        let current = Rainbow.extractModesForString(self)
        return Rainbow.generateStringForColor(
            current.color,
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
    public func stringByApplying(codes: ModeCode...) -> String {
        
        guard Rainbow.enabled else {
            return self
        }
        
        let current = Rainbow.extractModesForString(self)
        let input = ConsoleCodesParser().parseModeCodes( codes.map{ $0.value } )
        
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
            return Rainbow.generateStringForColor(
                color,
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
    public var black: String { return stringByApplyingColor(.Black) }
    /// String with red text.
    public var red: String { return stringByApplyingColor(.Red)   }
    /// String with green text.
    public var green: String { return stringByApplyingColor(.Green) }
    /// String with yellow text.
    public var yellow: String { return stringByApplyingColor(.Yellow) }
    /// String with blue text.
    public var blue: String { return stringByApplyingColor(.Blue) }
    /// String with magenta text.
    public var magenta: String { return stringByApplyingColor(.Magenta) }
    /// String with cyan text.
    public var cyan: String { return stringByApplyingColor(.Cyan) }
    /// String with white text.
    public var white: String { return stringByApplyingColor(.White) }
    /// String with light black text. Generally speaking, it means dark grey in some consoles.
    public var lightBlack: String { return stringByApplyingColor(.LightBlack) }
    /// String with light red text.
    public var lightRed: String { return stringByApplyingColor(.LightRed) }
    /// String with light green text.
    public var lightGreen: String { return stringByApplyingColor(.LightGreen) }
    /// String with light yellow text.
    public var lightYellow: String { return stringByApplyingColor(.LightYellow) }
    /// String with light blue text.
    public var lightBlue: String { return stringByApplyingColor(.LightBlue) }
    /// String with light magenta text.
    public var lightMagenta: String { return stringByApplyingColor(.LightMagenta) }
    /// String with light cyan text.
    public var lightCyan: String { return stringByApplyingColor(.LightCyan) }
    /// String with light white text. Generally speaking, it means light grey in some consoles.
    public var lightWhite: String { return stringByApplyingColor(.LightWhite) }
}

// MARK: - Background Colors Shorthand
extension String {
    /// String with black background.
    public var onBlack: String { return stringByApplyingBackgroundColor(.Black) }
    /// String with red background.
    public var onRed: String { return stringByApplyingBackgroundColor(.Red)   }
    /// String with green background.
    public var onGreen: String { return stringByApplyingBackgroundColor(.Green) }
    /// String with yellow background.
    public var onYellow: String { return stringByApplyingBackgroundColor(.Yellow) }
    /// String with blue background.
    public var onBlue: String { return stringByApplyingBackgroundColor(.Blue) }
    /// String with magenta background.
    public var onMagenta: String { return stringByApplyingBackgroundColor(.Magenta) }
    /// String with cyan background.
    public var onCyan: String { return stringByApplyingBackgroundColor(.Cyan) }
    /// String with white background.
    public var onWhite: String { return stringByApplyingBackgroundColor(.White) }
}

// MARK: - Styles Shorthand
extension String {
    /// String with bold style.
    public var bold: String { return stringByApplyingStyle(.Bold) }
    /// String with dim style. This is not widely supported in all terminals. Use it carefully.
    public var dim: String { return stringByApplyingStyle(.Dim) }
    /// String with italic style. This depends on whether a italic existing for the font family of terminals.
    public var italic: String { return stringByApplyingStyle(.Italic) }
    /// String with underline style.
    public var underline: String { return stringByApplyingStyle(.Underline) }
    /// String with blink style. This is not widely supported in all terminals, or need additional setting. Use it carefully.
    public var blink: String { return stringByApplyingStyle(.Blink) }
    /// String with text color and background color swapped.
    public var swap: String { return stringByApplyingStyle(.Swap) }
}

// MARK: - Clear Modes Shorthand
extension String {
    /// Clear color component from string.
    public var clearColor: String { return stringByRemovingColor() }
    /// Clear background color component from string.
    public var clearBackgroundColor: String { return stringByRemovingBackgroundColor() }
    /// Clear styles components from string.
    public var clearStyles: String { return stringByRemovingAllStyles() }
}

