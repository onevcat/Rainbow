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

    public struct Segment {
        public var text: String
        public var color: ColorType?
        public var backgroundColor: BackgroundColorType?
        public var styles: [Style]?

        public init(text: String, color: ColorType? = nil, backgroundColor: BackgroundColorType? = nil, styles: [Style]? = nil) {
            self.text = text
            self.color = color
            self.backgroundColor = backgroundColor
            self.styles = styles
        }

        public var isPlain: Bool {
            return color == nil && backgroundColor == nil && (styles == nil || styles!.isEmpty || styles == [.default])
        }

        mutating func update(with input: ParseResult, overwriteColor: Bool) {
            if isPlain { // Remove the `.default` style for plain segment
                styles = nil
            }

            if let color = input.color, (self.color == nil || overwriteColor) {
                self.color = color
            }
            if let backgroundColor = input.backgroundColor, (self.backgroundColor == nil || overwriteColor) {
                self.backgroundColor = backgroundColor
            }

            var styles = self.styles ?? []
            if let s = input.styles {
                styles += s
            }
            self.styles = styles
        }
    }

    public struct Entry {

        public var segments: [Segment]

        public init(segments: [Segment]) {
            self.segments = segments
        }

        public var plainText: String {
            return segments.reduce("") { $0 + $1.text }
        }

        public var isPlain: Bool {
            return segments.allSatisfy { $0.isPlain }
        }
    }
    
    /// Output target for `Rainbow`. `Rainbow` should detect correct target itself, so you rarely need to set it. 
    /// However, if you want the colorized string to be different, or the detection is not correct, you can set it manually.
    public static var outputTarget = OutputTarget.current
    
    /// Enable `Rainbow` to colorize string or not. Default is `true`, unless the `NO_COLOR` environment variable is set.
    public static var enabled = ProcessInfo.processInfo.environment["NO_COLOR"] == nil

    public static func extractEntry(for string: String) -> Entry {
        return ConsoleEntryParser(text: string).parse()
    }

    @available(*, deprecated, message: "Use the `Entry` version `extractEntry(for:)` instead.")
    public static func extractModes(for string: String)
        -> (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String)
    {
        let entry = ConsoleEntryParser(text: string).parse()
        if let segment = entry.segments.first {
            return (segment.color?.namedColor, segment.backgroundColor?.namedColor, segment.styles, segment.text)
        } else {
            return (nil, nil, nil, "")
        }
    }

    static func generateString(for entry: Entry) -> String {
        guard enabled else {
            return entry.plainText
        }
        switch outputTarget {
        case .console:
            return ConsoleStringGenerator().generate(for: entry)
        case .unknown:
            return entry.plainText
        }
    }
}
