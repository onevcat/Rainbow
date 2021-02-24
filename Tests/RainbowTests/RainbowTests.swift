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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractModesNotMatch() {
        let result1 = Rainbow.extractEntry(for: "abc")
        XCTAssertNil(result1.color)
        XCTAssertNil(result1.backgroundColor)
        XCTAssertNil(result1.styles)
        XCTAssertEqual(result1.text, "abc")
        
        let result2 = Rainbow.extractEntry(for: "\u{001B}[0mHello\u{001B}")
        XCTAssertNil(result2.color)
        XCTAssertNil(result2.backgroundColor)
        XCTAssertNil(result2.styles)
        XCTAssertEqual(result2.text, "\u{001B}[0mHello\u{001B}")
        
        let result3 = Rainbow.extractEntry(for: "\u{001B}[fg0,0,0;Hello\u{001B}")
        XCTAssertNil(result3.color)
        XCTAssertNil(result3.backgroundColor)
        XCTAssertNil(result3.styles)
        XCTAssertEqual(result3.text, "\u{001B}[fg0,0,0;Hello\u{001B}")
    }
    
    func testExtractModes() {
        let result1 = Rainbow.extractEntry(for: "\u{001B}[0m\u{001B}[0m")
        XCTAssertNil(result1.color)
        XCTAssertNil(result1.backgroundColor)
        XCTAssertEqual(result1.styles!, [.default])
        XCTAssertEqual(result1.text, "")
        
        let result2 = Rainbow.extractEntry(for: "\u{001B}[31mHello World\u{001B}[0m")
        XCTAssertEqual(result2.color?.namedColor, Color.red)
        XCTAssertNil(result2.backgroundColor)
        XCTAssertNil(result2.styles)
        XCTAssertEqual(result2.text, "Hello World")
        
        let result3 = Rainbow.extractEntry(for: "\u{001B}[4;31;42;93;5mHello World\u{001B}[0m")
        XCTAssertEqual(result3.color?.namedColor, Color.lightYellow)
        XCTAssertEqual(result3.backgroundColor?.namedColor, BackgroundColor.green)
        XCTAssertEqual(result3.styles!, [.underline, .blink])
        XCTAssertEqual(result3.text, "Hello World")
        
        let result4 = Rainbow.extractEntry(for: "\u{001B}[31m\u{001B}[4;31;93mHello World\u{001B}[0m\u{001B}[0m")
        XCTAssertEqual(result4.color?.namedColor, Color.red)
        XCTAssertNil(result4.backgroundColor)
        XCTAssertNil(result4.styles)
        XCTAssertEqual(result4.text, "\u{001B}[4;31;93mHello World\u{001B}[0m")
    }

    func testExtract8BitModes() {
        // normal case
        let result = Rainbow.extractEntry(for: "\u{001B}[38;5;31mHello World\u{001B}[0m")
        XCTAssertEqual(result.color, .bit8(31))
        XCTAssertEqual(result.text, "Hello World")

        // set color, but no 8bit control code (`5`)
        let result1 = Rainbow.extractEntry(for: "\u{001B}[38;31mHello World\u{001B}[0m")
        XCTAssertEqual(result1.color, .named(.red))
        XCTAssertEqual(result1.text, "Hello World")

        // with additional style
        let result2 = Rainbow.extractEntry(for: "\u{001B}[38;5;155;4mHello World\u{001B}[0m")
        XCTAssertEqual(result2.color, .bit8(155))
        XCTAssertEqual(result2.styles, [.underline])
        XCTAssertEqual(result2.text, "Hello World")

        // set color, but no 8bit control code (`5`)
        let result3 = Rainbow.extractEntry(for: "\u{001B}[38;4mHello World\u{001B}[0m")
        XCTAssertEqual(result3.color, nil)
        XCTAssertEqual(result3.styles, [.underline])
        XCTAssertEqual(result3.text, "Hello World")
    }

    func testExtract24bitModes() {
        // normal case
        let result = Rainbow.extractEntry(for: "\u{001B}[38;2;100;100;100mHello World\u{001B}[0m")
        XCTAssertEqual(result.color, .bit24((100, 100, 100)))
        XCTAssertEqual(result.text, "Hello World")

        // set color, but no 8bit control code (`2`)
        let result1 = Rainbow.extractEntry(for: "\u{001B}[38;31mHello World\u{001B}[0m")
        XCTAssertEqual(result1.color, .named(.red))
        XCTAssertEqual(result1.text, "Hello World")

        // with additional style
        let result2 = Rainbow.extractEntry(for: "\u{001B}[38;2;100;100;100;4mHello World\u{001B}[0m")
        XCTAssertEqual(result.color, .bit24((100, 100, 100)))
        XCTAssertEqual(result2.styles, [.underline])
        XCTAssertEqual(result2.text, "Hello World")

        // set color, but no 8bit control code (`2`)
        let result3 = Rainbow.extractEntry(for: "\u{001B}[38;4mHello World\u{001B}[0m")
        XCTAssertEqual(result3.color, nil)
        XCTAssertEqual(result3.styles, [.underline])
        XCTAssertEqual(result3.text, "Hello World")

        // set color, but not enough color component
        let result4 = Rainbow.extractEntry(for: "\u{001B}[38;2;4;5mHello World\u{001B}[0m")
        XCTAssertEqual(result4.color, nil)
        XCTAssertEqual(result4.styles, [.dim, .underline, .blink])
        XCTAssertEqual(result4.text, "Hello World")
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
