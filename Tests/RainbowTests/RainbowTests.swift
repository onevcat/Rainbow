//
//  RainbowTests.swift
//  RainbowTests
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

import XCTest
@testable import Rainbow

class RainbowTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Rainbow.outputTarget = .console
        Rainbow.enabled = true
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractModesNotMatch() {
        let result1 = Rainbow.extractEntry(for: "abc")
        XCTAssertNil(result1.segments[0].color)
        XCTAssertNil(result1.segments[0].backgroundColor)
        XCTAssertNil(result1.segments[0].styles)
        XCTAssertEqual(result1.segments[0].text, "abc")
        
        let result2 = Rainbow.extractEntry(for: "\u{001B}[0mHello\u{001B}")
        XCTAssertNil(result2.segments[0].color)
        XCTAssertNil(result2.segments[0].backgroundColor)
        XCTAssertEqual(result2.segments[0].styles, [.default])
        XCTAssertEqual(result2.segments[0].text, "Hello")
        
        let result3 = Rainbow.extractEntry(for: "\u{001B}[fg0,0,0;Hello\u{001B}")
        XCTAssertTrue(result3.segments.isEmpty)
    }
    
    func testExtractModes() {
        let result1 = Rainbow.extractEntry(for: "\u{001B}[0m\u{001B}[0m")
        XCTAssertNil(result1.segments[0].color)
        XCTAssertNil(result1.segments[0].backgroundColor)
        XCTAssertEqual(result1.segments[0].styles!, [.default])
        XCTAssertEqual(result1.segments[0].text, "")
        
        let result2 = Rainbow.extractEntry(for: "\u{001B}[31mHello World\u{001B}[0m")
        XCTAssertEqual(result2.segments[0].color, .named(.red))
        XCTAssertNil(result2.segments[0].backgroundColor)
        XCTAssertNil(result2.segments[0].styles)
        XCTAssertEqual(result2.segments[0].text, "Hello World")
        
        let result3 = Rainbow.extractEntry(for: "\u{001B}[4;31;42;93;5mHello World\u{001B}[0m")
        XCTAssertEqual(result3.segments[0].color, .named(.lightYellow))
        XCTAssertEqual(result3.segments[0].backgroundColor, .named(.green))
        XCTAssertEqual(result3.segments[0].styles!, [.underline, .blink])
        XCTAssertEqual(result3.segments[0].text, "Hello World")
        
        let result4 = Rainbow.extractEntry(for: "\u{001B}[31m\u{001B}[4;31;93mHello World\u{001B}[0m\u{001B}[0m")
        XCTAssertEqual(result4.segments[0].color, .named(.red))
        XCTAssertNil(result4.segments[0].backgroundColor)
        XCTAssertNil(result4.segments[0].styles)
        XCTAssertEqual(result4.segments[0].text, "")

        XCTAssertEqual(result4.segments[1].color, .named(.lightYellow))
        XCTAssertNil(result4.segments[1].backgroundColor)
        XCTAssertEqual(result4.segments[1].styles, [.underline])
        XCTAssertEqual(result4.segments[1].text, "Hello World")
    }

    func testExtract8BitModes() {
        // normal case
        let result = Rainbow.extractEntry(for: "\u{001B}[38;5;31mHello World\u{001B}[0m")
        XCTAssertEqual(result.segments[0].color, .bit8(31))
        XCTAssertEqual(result.segments[0].text, "Hello World")

        // set color, but no 8bit control code (`5`)
        let result1 = Rainbow.extractEntry(for: "\u{001B}[38;31mHello World\u{001B}[0m")
        XCTAssertEqual(result1.segments[0].color, .named(.red))
        XCTAssertEqual(result1.segments[0].text, "Hello World")

        // with additional style
        let result2 = Rainbow.extractEntry(for: "\u{001B}[38;5;155;4mHello World\u{001B}[0m")
        XCTAssertEqual(result2.segments[0].color, .bit8(155))
        XCTAssertEqual(result2.segments[0].styles, [.underline])
        XCTAssertEqual(result2.segments[0].text, "Hello World")

        // set color, but no 8bit control code (`5`)
        let result3 = Rainbow.extractEntry(for: "\u{001B}[38;4mHello World\u{001B}[0m")
        XCTAssertEqual(result3.segments[0].color, nil)
        XCTAssertEqual(result3.segments[0].styles, [.underline])
        XCTAssertEqual(result3.segments[0].text, "Hello World")
    }

    func testExtract24bitModes() {
        // normal case
        let result = Rainbow.extractEntry(for: "\u{001B}[38;2;100;100;100mHello World\u{001B}[0m")
        XCTAssertEqual(result.segments[0].color, .bit24((100, 100, 100)))
        XCTAssertEqual(result.segments[0].text, "Hello World")

        // set color, but no 8bit control code (`2`)
        let result1 = Rainbow.extractEntry(for: "\u{001B}[38;31mHello World\u{001B}[0m")
        XCTAssertEqual(result1.segments[0].color, .named(.red))
        XCTAssertEqual(result1.segments[0].text, "Hello World")

        // with additional style
        let result2 = Rainbow.extractEntry(for: "\u{001B}[38;2;100;100;100;4mHello World\u{001B}[0m")
        XCTAssertEqual(result.segments[0].color, .bit24((100, 100, 100)))
        XCTAssertEqual(result2.segments[0].styles, [.underline])
        XCTAssertEqual(result2.segments[0].text, "Hello World")

        // set color, but no 8bit control code (`2`)
        let result3 = Rainbow.extractEntry(for: "\u{001B}[38;4mHello World\u{001B}[0m")
        XCTAssertEqual(result3.segments[0].color, nil)
        XCTAssertEqual(result3.segments[0].styles, [.underline])
        XCTAssertEqual(result3.segments[0].text, "Hello World")

        // set color, but not enough color component
        let result4 = Rainbow.extractEntry(for: "\u{001B}[38;2;4;5mHello World\u{001B}[0m")
        XCTAssertEqual(result4.segments[0].color, nil)
        XCTAssertEqual(result4.segments[0].styles, [.dim, .underline, .blink])
        XCTAssertEqual(result4.segments[0].text, "Hello World")
    }
    
    func testGenerateStringWithSegments() {
        let entry = Rainbow.Entry(segments: [
            .init(text: "Hello", color: .bit8(214), backgroundColor: .named(.black), styles: [.underline]),
            .init(text: "World", color: .named(.magenta))
        ])
        let result = Rainbow.generateString(for: entry)
        XCTAssertEqual(result, "\u{001B}[38;5;214;40;4mHello\u{001B}[0m\u{001B}[35mWorld\u{001B}[0m")
    }
    
    func testGenerateConsoleStringWithCodes() {
        
        Rainbow.outputTarget = .console

        let result1 = Rainbow.generateString(for: .init(text: "Hello"))
        XCTAssertEqual(result1, "Hello")

        let result2 = Rainbow.generateString(for: .init(color: .named(.red), backgroundColor: nil, styles: nil, text: "Hello"))
        XCTAssertEqual(result2, "\u{001B}[31mHello\u{001B}[0m")

        let result3 = Rainbow.generateString(
            for: .init(color: .named(.lightYellow), backgroundColor: .named(.magenta), styles: [.bold, .blink], text: "Hello")
        )
        XCTAssertEqual(result3, "\u{001B}[93;45;1;5mHello\u{001B}[0m")
    }

    func testGenerateConsoleStringWithCodes8Bit() {
        let result1 = Rainbow.generateString(
            for: .init(color: .bit8(100), backgroundColor: nil, styles: nil, text: "Hello")
        )
        XCTAssertEqual(result1, "\u{001B}[38;5;100mHello\u{001B}[0m")

        let result2 = Rainbow.generateString(
            for: .init(color: nil, backgroundColor: .bit8(200), styles: [], text: "Hello")
        )
        XCTAssertEqual(result2, "\u{001B}[48;5;200mHello\u{001B}[0m")

        let result3 = Rainbow.generateString(
            for: .init(color: .bit8(100), backgroundColor: .bit8(200), styles: [.bold], text: "Hello")
        )
        XCTAssertEqual(result3, "\u{001B}[38;5;100;48;5;200;1mHello\u{001B}[0m")

        let result4 = Rainbow.generateString(
            for: .init(color: .named(.red), backgroundColor: .bit8(200), styles: [.bold], text: "Hello")
        )
        XCTAssertEqual(result4, "\u{001B}[31;48;5;200;1mHello\u{001B}[0m")
    }
    
    func testGenerateUnknownStringWithCodes() {
        Rainbow.outputTarget = .unknown
        
        let result1 = Rainbow.generateString(for: .init(text: "Hello"))
        XCTAssertEqual(result1, "Hello")
        
        let result2 = Rainbow.generateString(for: .init(color: .named(.red), backgroundColor: nil, styles: nil, text: "Hello"))
        XCTAssertEqual(result2, "Hello")
        
        let result3 = Rainbow.generateString(
            for: .init(color: .named(.lightYellow), backgroundColor: .named(.magenta), styles: [.bold, .blink], text: "Hello")
        )
        XCTAssertEqual(result3, "Hello")
    }
    
    func testRainbowEnabled() {
        Rainbow.outputTarget = .console
        
        let result1 = "Hello".red
        XCTAssertEqual(result1, "\u{001B}[31mHello\u{001B}[0m")
        
        Rainbow.enabled = false
        
        let result2 = "Hello".red
        XCTAssertEqual(result2, "Hello")

        Rainbow.enabled = true
    }
    
    func testRainbowRawString() {
        let red = "\u{001B}[31mHello\u{001B}[0m"
        XCTAssertEqual(red.raw, "Hello")
        
        let plain = "Hello"
        XCTAssertEqual(plain, "Hello")
    }
}

extension Rainbow.Entry {
    init(color: ColorType? = nil, backgroundColor: BackgroundColorType? = nil, styles: [Style]? = nil, text: String) {
        let s = Rainbow.Segment(text: text, color: color, backgroundColor: backgroundColor, styles: styles)
        self.init(segments: [s])
    }
}
