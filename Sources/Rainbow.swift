//
//  Rainbow.swift
//  Rainbow
//
//  Created by WANG WEI on 2015/12/22.
//  Copyright © 2015年 OneV's Den. All rights reserved.
//

public protocol ModeCode {
    var value: UInt8 { get }
}

struct Rainbow {
    
    static func extractModeCodesForString(string: String) -> (codes: [UInt8], text: String) {
        let token = ControlCode.CSI
        if string.hasPrefix(token) && string.hasSuffix("\(token)0m") {
            var index = string.startIndex.advancedBy(token.characters.count)
            var codesString = ""
            while string.characters[index] != "m" {
                codesString.append(string.characters[index])
                index = index.successor()
            }
            
            let codes = codesString.characters.split(";").flatMap { UInt8(String($0)) }
            
            let startIndex = index.successor()
            let endIndex = string.endIndex.advancedBy(-"\(token)0m".characters.count)
            let text = String(string.characters[startIndex ..< endIndex])
            
            return (codes, text)
        } else {
            return ([], string)
        }
    }
    
    static func extractModesForString(string: String)
        -> (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String) {

        let result = extractModeCodesForString(string)
        let (color, backgroundColor, styles) = formatModeCodes(result.codes)
            
        return (color, backgroundColor, styles, result.text)
    }
    
    static func formatModeCodes(codes: [UInt8]) -> (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?) {
        var color: Color? = nil
        var backgroundColor: BackgroundColor? = nil
        var styles: [Style]? = nil
        
        for code in codes {
            if let c = Color(rawValue: code) {
                color = c
            } else if let bg = BackgroundColor(rawValue: code) {
                backgroundColor = bg
            } else if let style = Style(rawValue: code) {
                if styles == nil {
                    styles = []
                }
                styles!.append(style)
            }
        }
        
        return (color, backgroundColor, styles)
    }
    
    static func generateStringWithCodes(codes: [ModeCode], text: String) -> String {
        return "\(ControlCode.CSI)\(codes.map{String($0.value)}.joinWithSeparator(";"))m\(text)\(ControlCode.CSI)0m"
    }
}

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
    
    public func stringByRemovingBackgroundColor(color: BackgroundColor) -> String {
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

extension String {
    public var black: String {
        return stringByApplyingColor(.Black)
    }
    
    public var red: String {
        return stringByApplyingColor(.Red)
    }
    
}