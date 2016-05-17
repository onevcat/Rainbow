//
//  Rainbow.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/22.
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
    public static var outputTarget = OutputTarget.currentOutputTarget
    
    /// Enable `Rainbow` to colorize string or not. Default is `true`.
    public static var enabled = true
    
    static func extractModesForString(string: String)
        -> (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String)
    {
        if string.isConsoleStyle {
            #if swift(>=3.0)
                let result = ConsoleModesExtractor().extractModeCodes(string: string)
                let (color, backgroundColor, styles) = ConsoleCodesParser().parseModeCodes(codes: result.codes)
            #else
                let result = ConsoleModesExtractor().extractModeCodes(string)
                let (color, backgroundColor, styles) = ConsoleCodesParser().parseModeCodes(result.codes)
            #endif
            return (color, backgroundColor, styles, result.text)
        } else if string.isXcodeColorsStyle {
            #if swift(>=3.0)
                let result = XcodeColorsModesExtractor().extractModeCodes(string: string)
                let (color, backgroundColor, _) = XcodeColorsCodesParser().parseModeCodes(codes: result.codes)
            #else
                let result = XcodeColorsModesExtractor().extractModeCodes(string)
                let (color, backgroundColor, _) = XcodeColorsCodesParser().parseModeCodes(result.codes)
            #endif
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
        #if swift(>=3.0)
        switch outputTarget {
        case .XcodeColors:
            return XcodeColorsStringGenerator().generateStringColor(color: color, backgroundColor: backgroundColor, styles: styles, text: text)
        case .Console:
            return ConsoleStringGenerator().generateStringColor(color: color, backgroundColor: backgroundColor, styles: styles, text: text)
        case .Unknown:
            return text
            }
        #else
        switch outputTarget {
        case .XcodeColors:
            return XcodeColorsStringGenerator().generateStringColor(color, backgroundColor: backgroundColor, styles: styles, text: text)
        case .Console:
            return ConsoleStringGenerator().generateStringColor(color, backgroundColor: backgroundColor, styles: styles, text: text)
        case .Unknown:
            return text
            }
        #endif
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