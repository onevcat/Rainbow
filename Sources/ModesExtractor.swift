//
//  ModesExtractor.swift
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

// Parse a console string to `Entry`
class ConsoleEntryParser {

    let text: String
    var iter: String.Iterator?

    init(text: String) {
        self.text = text
    }

    // Not thread safe.
    func parse() -> Rainbow.Entry {

        func appendSegment(text: String, codes: [UInt8]) {
            let modes = ConsoleCodesParser().parse(modeCodes: codes)
            segments.append(.init(text: text, color: modes.color, backgroundColor: modes.backgroundColor, styles: modes.styles))
            tempCodes = []
        }

        iter = text.makeIterator()

        var segments = [Rainbow.Segment]()
        var tempCodes = [UInt8]()
        var startingNewSegment = false

        while let c = iter!.next() {
            if startingNewSegment, c == ControlCode.OPEN_BRACKET {
                tempCodes = parseCodes()
                startingNewSegment = false
            } else if c == ControlCode.ESC {
                if !tempCodes.isEmpty {
                    appendSegment(text: "", codes: tempCodes)
                }
                startingNewSegment = true
            } else {
                let text = parseText(firstCharacter: c)
                appendSegment(text: text, codes: tempCodes)
                startingNewSegment = true
            }
        }

        return Rainbow.Entry(segments: segments)
    }

    func parseCodes() -> [UInt8] {
        var codes = [UInt8]()
        var current: String = ""
        while let c = iter!.next(), c != "m" {
            if c == ";", let code = UInt8(current) {
                codes.append(code)
                current = ""
            } else {
                current.append(c)
            }
        }
        if let code = UInt8(current) {
            codes.append(code)
        }
        return codes
    }

    func parseText(firstCharacter: Character) -> String {
        var text = String(firstCharacter)
        while let c = iter!.next(), c != ControlCode.ESC {
            text.append(c)
        }
        return text
    }
}
