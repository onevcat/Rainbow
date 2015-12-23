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

public struct Rainbow {
    
    public static var outputTarget = OutputTarget.currentOutputTarget
    
    static func extractModeCodesForString(string: String) -> (codes: [UInt8], text: String) {
        let token = ControlCode.CSI

        if string.hasPrefix(token) && string.hasSuffix("\(token)0m") {
            // Console style
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
        } else if string.hasPrefix(token) && string.hasSuffix("\(token);") {
            // Xcode Colors style
            return ([], string)
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
    
    static func generateStringForTarget(target: OutputTarget,
                                         color: Color?,
                               backgroundColor: BackgroundColor?,
                                        styles: [Style]?, text: String) -> String
    {
        
        func generateConsoleStringWithCodes(codes: [ModeCode], text: String) -> String {
            if codes.isEmpty {
                return text
            } else {
                return "\(ControlCode.CSI)\(codes.map{String($0.value)}.joinWithSeparator(";"))m\(text)\(ControlCode.CSI)0m"
            }
        }
        
        func generateXcodeColorsStringWithColor(color: Color?, backgroundColor: BackgroundColor?, text: String) -> String {
            
            let hasAttributes = color != nil || backgroundColor != nil
            if hasAttributes {
                var result = ""
                if let color = color where color != .Default {
                    result += "\(ControlCode.CSI)\(color.xcodeColorsDescription);"
                }
                
                if let backgroundColor = backgroundColor where backgroundColor != .Default {
                    result += "\(ControlCode.CSI)\(backgroundColor.xcodeColorsDescription);"
                }
                
                result += text
                result += "\(ControlCode.CSI);"
                
                return result
            } else {
                return text
            }
        }
        
        switch target {
        case .XcodeColors:
            return generateXcodeColorsStringWithColor(color, backgroundColor: backgroundColor, text: text)
        case .Console:
            var codes: [ModeCode] = []
            if let color = color {
                codes.append(color)
            }
            if let backgroundColor = backgroundColor {
                codes.append(backgroundColor)
            }
            if let styles = styles {
                codes += styles.map{$0 as ModeCode}
            }
            return generateConsoleStringWithCodes(codes, text: text)
        case .Unknown:
            return text
        }
    }
    
}
