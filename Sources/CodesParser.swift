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

typealias ParseResult = (color: ColorType?, backgroundColor: BackgroundColorType?, styles: [Style]?)

protocol CodesParser {
    associatedtype SourceType
    func parse(modeCodes codes: [SourceType]) -> ParseResult
}

struct ConsoleCodesParser: CodesParser {

    enum CodeResult {
        case color(ColorType)
        case backgroundColor(BackgroundColorType)
        case style(Style)
    }

    func parse(modeCodes codes: [UInt8]) -> ParseResult {
        var color: ColorType? = nil
        var backgroundColor: BackgroundColorType? = nil
        var styles: [Style]? = nil

        var iter = codes.makeIterator()
        while let code = iter.next() {
            if code == ControlCode.setColor {
                if canParseToSetBit8(iter) {
                    _ = iter.next() // set 8bit control
                    let colorCode = iter.next()!
                    color = .bit8(colorCode)
                } else if canParseToSetBit24(iter) {
                    _ = iter.next() // set 24 bit control
                    let r = iter.next()!
                    let g = iter.next()!
                    let b = iter.next()!
                    color = .bit24((r, g, b))
                }
            } else if code == ControlCode.setBackgroundColor {
                if canParseToSetBit8(iter) {
                    _ = iter.next() // set 8bit control
                    let colorCode = iter.next()!
                    backgroundColor = .bit8(colorCode)
                } else if canParseToSetBit24(iter) {
                    _ = iter.next() // set 24 bit control
                    let r = iter.next()!
                    let g = iter.next()!
                    let b = iter.next()!
                    backgroundColor = .bit24((r, g, b))
                }
            } else {
                switch parseOne(code) {
                case .color(let c): color = c
                case .backgroundColor(let bg): backgroundColor = bg
                case .style(let style):
                    if styles == nil {
                        styles = []
                    }
                    styles!.append(style)
                case .none: break
                }
            }
        }
        return (color, backgroundColor, styles)
    }

    func parseOne(_ code: UInt8) -> CodeResult? {
        if let c = NamedColor(rawValue: code) {
            return .color(.named(c))
        } else if let bg = NamedBackgroundColor(rawValue: code) {
            return .backgroundColor(.named(bg))
        } else if let style = Style(rawValue: code) {
            return .style(style)
        }
        return nil
    }

    func canParseToSetBit8(_ iter: IndexingIterator<[UInt8]>) -> Bool {
        var ownedIter = iter
        guard let controlCode = ownedIter.next(), controlCode == ControlCode.set8Bit else {
            return false
        }
        guard let _ = ownedIter.next() else {
            return false
        }
        return true
    }

    func canParseToSetBit24(_ iter: IndexingIterator<[UInt8]>) -> Bool {
        var ownedIter = iter
        guard let controlCode = ownedIter.next(), controlCode == ControlCode.set24Bit else {
            return false
        }
        guard let _ = ownedIter.next(), let _ = ownedIter.next(), let _ = ownedIter.next() else {
            return false
        }
        return true
    }
}
