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
    public static var enabled = true
    
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

    static func generateStringForColor(color: Color?,
                             backgroundColor: BackgroundColor?,
                                      styles: [Style]?,
                                        text: String) -> String
    {
        guard enabled else {
            return text
        }
        
        switch outputTarget {
        case .XcodeColors:
            return XcodeColorsStringGenerator().generateStringColor(color, backgroundColor: backgroundColor, styles: styles, text: text)
        case .Console:
            return ConsoleStringGenerator().generateStringColor(color, backgroundColor: backgroundColor, styles: styles, text: text)
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