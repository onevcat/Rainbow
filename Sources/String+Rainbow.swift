//
//  String+Rainbow.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/23.
//  Copyright © 2015年 OneV's Den. All rights reserved.
//

// MARK: - Worker methods
extension String {
    public func stringByApplyingColor(color: Color) -> String {
        return stringByApplying(color)
    }
    
    public func stringByRemovingColor() -> String {
        guard let _ = Rainbow.extractModesForString(self).color else {
            return self
        }
        return stringByApplyingColor(.Default)
    }
    
    public func stringByApplyingBackgroundColor(color: BackgroundColor) -> String {
        return stringByApplying(color)
    }
    
    public func stringByRemovingBackgroundColor() -> String {
        guard let _ = Rainbow.extractModesForString(self).backgroundColor else {
            return self
        }
        return stringByApplyingBackgroundColor(.Default)
    }
    
    public func stringByApplyingStyle(style: Style) -> String {
        return stringByApplying(style)
    }
    
    public func stringByRemovingStyle(style: Style) -> String {
        let current = Rainbow.extractModesForString(self)
        if let styles = current.styles {
            var s = styles
            var index = s.indexOf(style)
            while index != nil {
                s.removeAtIndex(index!)
                index = s.indexOf(style)
            }
            
            var codes = [ModeCode]()
            
            if let color = current.color {
                codes.append(color)
            }
            if let backgroundColor = current.backgroundColor {
                codes.append(backgroundColor)
            }
            codes += s.map{$0 as ModeCode}
            
            return Rainbow.generateStringWithCodes(codes, text: current.text)
        } else {
            return self
        }
    }
    
    public func stringByRemovingAllStyles() -> String {
        let current = Rainbow.extractModesForString(self)
        if let _ = current.styles {
            var codes = [ModeCode]()
            if let color = current.color {
                codes.append(color)
            }
            if let backgroundColor = current.backgroundColor {
                codes.append(backgroundColor)
            }
            return Rainbow.generateStringWithCodes(codes, text: current.text)
        } else {
            return self
        }
    }
    
    public func stringByApplying(codes: ModeCode...) -> String {
        
        let current = Rainbow.extractModesForString(self)
        let input = Rainbow.formatModeCodes( codes.map{ $0.value } )
        
        var codes = [ModeCode]()
        
        if let color = input.color {
            codes.append(color)
        } else if let color = current.color {
            codes.append(color)
        }
        
        if let backgroundColor = input.backgroundColor {
            codes.append(backgroundColor)
        } else if let backgroundColor = current.backgroundColor {
            codes.append(backgroundColor)
        }
        
        if let styles = current.styles {
            codes += styles.map{$0 as ModeCode}
        }
        
        if let styles = input.styles {
            codes += styles.map{$0 as ModeCode}
        }
        
        if codes.isEmpty {
            return self
        } else {
            return Rainbow.generateStringWithCodes(codes, text: current.text)
        }
    }
}

// MARK: - Colors Shorthand
extension String {
    public var black: String { return stringByApplyingColor(.Black) }
    public var red: String { return stringByApplyingColor(.Red)   }
    public var green: String { return stringByApplyingColor(.Green) }
    public var yellow: String { return stringByApplyingColor(.Yellow) }
    public var blue: String { return stringByApplyingColor(.Blue) }
    public var magenta: String { return stringByApplyingColor(.Magenta) }
    public var cyan: String { return stringByApplyingColor(.Cyan) }
    public var white: String { return stringByApplyingColor(.White) }
    public var lightBlack: String { return stringByApplyingColor(.LightBlack) }
    public var lightRed: String { return stringByApplyingColor(.LightRed) }
    public var lightGreen: String { return stringByApplyingColor(.LightGreen) }
    public var lightYellow: String { return stringByApplyingColor(.LightYellow) }
    public var lightBlue: String { return stringByApplyingColor(.LightBlue) }
    public var lightMagenta: String { return stringByApplyingColor(.LightMagenta) }
    public var lightCyan: String { return stringByApplyingColor(.LightCyan) }
    public var lightWhite: String { return stringByApplyingColor(.LightWhite) }
}

// MARK: - Background Colors Shorthand
extension String {
    public var onBlack: String { return stringByApplyingBackgroundColor(.Black) }
    public var onRed: String { return stringByApplyingBackgroundColor(.Red)   }
    public var onGreen: String { return stringByApplyingBackgroundColor(.Green) }
    public var onYellow: String { return stringByApplyingBackgroundColor(.Yellow) }
    public var onBlue: String { return stringByApplyingBackgroundColor(.Blue) }
    public var onMagenta: String { return stringByApplyingBackgroundColor(.Magenta) }
    public var onCyan: String { return stringByApplyingBackgroundColor(.Cyan) }
    public var onWhite: String { return stringByApplyingBackgroundColor(.White) }
}

// MARK: - Styles Shorthand
extension String {
    public var bold: String { return stringByApplyingStyle(.Bold) }
    public var dim: String { return stringByApplyingStyle(.Dim) }
    public var italic: String { return stringByApplyingStyle(.Italic) }
    public var underline: String { return stringByApplyingStyle(.Underline) }
    public var blink: String { return stringByApplyingStyle(.Blink) }
    public var swap: String { return stringByApplyingStyle(.Swap) }
}

// MARK: - Clear Modes Shorthand
extension String {
    public var clearColor: String { return stringByRemovingColor() }
    public var clearBackgroundColor: String { return stringByRemovingBackgroundColor() }
    public var clearStyles: String { return stringByRemovingAllStyles() }
}

