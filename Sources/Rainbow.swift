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
    var value: [UInt8] { get }
}

/**
 Setting for `Rainbow`.
 */
public enum Rainbow {

    public enum Content {
        case text(String)
        case entry(Entry)

        #warning("Remove later")
        var asText: String {
            switch self {
            case .text(let t): return t
            case .entry: fatalError()
            }
        }
    }

    public struct Entry {

        public var color: ColorType?
        public var backgroundColor: BackgroundColorType?
        public var styles: [Style]?
        public var contents: [Content]

        #warning("Remove later")
        var text: String { return contents[0].asText }

        init(color: ColorType? = nil, backgroundColor: BackgroundColorType? = nil, styles: [Style]? = nil, text: String) {
            self.color = color
            self.backgroundColor = backgroundColor
            self.styles = styles
            self.contents = [.text(text)]
        }

        init(formattedString string: String) {
            if string.isConsoleStyle {
                let result = ConsoleModesExtractor().extract(string)
                let (color, backgroundColor, styles) = ConsoleCodesParser().parse(modeCodes: result.codes)
                self.color = color
                self.backgroundColor = backgroundColor
                self.styles = styles
                self.contents = [.text(result.text)]
            } else {
                self.contents = [.text(string)]
            }
        }
    }
    
    /// Output target for `Rainbow`. `Rainbow` should detect correct target itself, so you rarely need to set it. 
    /// However, if you want the colorized string to be different, or the detection is not correct, you can set it manually.
    public static var outputTarget = OutputTarget.current
    
    /// Enable `Rainbow` to colorize string or not. Default is `true`, unless the `NO_COLOR` environment variable is set.
    public static var enabled = ProcessInfo.processInfo.environment["NO_COLOR"] == nil

    public static func extractEntry(for string: String) -> Entry {
        return Entry(formattedString: string)
    }

    @available(*, deprecated, message: "Use the `Entry` version `extractEntry(for:)` instead.")
    public static func extractModes(for string: String)
        -> (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String)
    {
        let entry = Entry(formattedString: string)
        
        return (entry.color?.namedColor, entry.backgroundColor?.namedColor, entry.styles, entry.contents[0].asText)
    }


    static func generateString(for entry: Entry) -> String {
        guard enabled else {
            return entry.contents[0].asText
        }
        switch outputTarget {
        case .console:
            return ConsoleStringGenerator().generate(for: entry)
        case .unknown:
            return entry.contents[0].asText
        }
    }
}

private extension String {
    var isConsoleStyle: Bool {
        let token = ControlCode.CSI
        return hasPrefix(token) && hasSuffix("\(token)0m")
    }
}
