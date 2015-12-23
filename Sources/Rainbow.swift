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
    
    static func extractModesForString(string: String)
        -> (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String)
    {
        if string.isConsoleStyle {
            let result = ConsoleModesExtractor().extractModeCodes(string)
            let (color, backgroundColor, styles) = ConsoleCodesParser().parseModeCodes(result.codes)
            return (color, backgroundColor, styles, result.text)
        } else if string.isXcodeColorsStyle {
            let result = XcodeColorsModesExtractor().extractModeCodes(string)
            let (color, backgroundColor, _) = XcodeColorsCodesParser().parseModeCodes(result.codes)
            return (color, backgroundColor, nil, result.text)
        } else {
            return (nil, nil, nil, string)
        }
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

private extension String {
    var isConsoleStyle: Bool {
        let token = ControlCode.CSI
        return hasPrefix(token) && hasSuffix("\(token)0m")
    }
    
    var isXcodeColorsStyle: Bool {
        let token = ControlCode.CSI
        return hasPrefix(token) && hasSuffix("\(token);")
    }
}