//
//  CodesParser.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/23.
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

typealias ParseResult = (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?)

protocol CodesParser {
    associatedtype SourceType
    func parse(modeCodes codes: [SourceType]) -> ParseResult
}

struct ConsoleCodesParser: CodesParser {
    func parse(modeCodes codes: [UInt8]) -> ParseResult {
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
}

struct XcodeColorsCodesParser: CodesParser {

    func parse(modeCodes codes: [String]) -> ParseResult {
        var color: Color? = nil
        var backgroundColor: BackgroundColor? = nil
        
        for code in codes {
            if let c = Color(xcodeColorsDescription: code) {
                color = c
            } else if let bg = BackgroundColor(xcodeColorsDescription: code) {
                backgroundColor = bg
            }
        }
        
        return (color, backgroundColor, nil)
    }
}
