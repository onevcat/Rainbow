//
//  Rainbow.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/22.
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

/**
 A Mode code represnet a component for colorizing the string.
 It could be a `Color`, a `BackgroundColor` or a `Style`
 */
public protocol ModeCode {
    var value: UInt8 { get }
}

/**
 Setting for `Rainbow`.
 */
public struct Rainbow {
    
    /// Output target for `Rainbow`. `Rainbow` should detect correct target itself, so you rarely need to set it. 
    /// However, if you want the colorized string to be different, or the detection is not correct, you can set it manually.
    public static var outputTarget = OutputTarget.current
    
    /// Enable `Rainbow` to colorize string or not. Default is `true`.
    public static var enabled = true
    
    public static func extractModes(for string: String)
        -> (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String)
    {
        if string.isConsoleStyle {
            let result = ConsoleModesExtractor().extract(string)
            let (color, backgroundColor, styles) = ConsoleCodesParser().parse(modeCodes: result.codes)
            return (color, backgroundColor, styles, result.text)
        } else if string.isXcodeColorsStyle {
            let result = XcodeColorsModesExtractor().extract(string)
            let (color, backgroundColor, _) = XcodeColorsCodesParser().parse(modeCodes: result.codes)
            return (color, backgroundColor, nil, result.text)
        } else {
            return (nil, nil, nil, string)
        }
    }

    static func generateString(forColor color: Color?,
                             backgroundColor: BackgroundColor?,
                                      styles: [Style]?,
                                        text: String) -> String
    {
        guard enabled else {
            return text
        }
        
        switch outputTarget {
        case .xcodeColors:
            return XcodeColorsStringGenerator()
                .generate(withStringColor: color,
                          backgroundColor: backgroundColor,
                          styles: styles,
                          text: text)
        case .console:
            return ConsoleStringGenerator()
                .generate(withStringColor: color,
                          backgroundColor: backgroundColor,
                          styles: styles,
                          text: text)
        case .unknown:
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
