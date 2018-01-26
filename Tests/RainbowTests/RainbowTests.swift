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
        let result1 = Rainbow.extractModes(for: "abc")
        XCTAssertNil(result1.color)
        XCTAssertNil(result1.backgroundColor)
        XCTAssertNil(result1.styles)
        XCTAssertEqual(result1.text, "abc")
        
        let result2 = Rainbow.extractModes(for: "\u{001B}[0mHello\u{001B}")
        XCTAssertNil(result2.color)
        XCTAssertNil(result2.backgroundColor)
        XCTAssertNil(result2.styles)
        XCTAssertEqual(result2.text, "\u{001B}[0mHello\u{001B}")
        
        let result3 = Rainbow.extractModes(for: "\u{001B}[fg0,0,0;Hello\u{001B}")
        XCTAssertNil(result3.color)
        XCTAssertNil(result3.backgroundColor)
        XCTAssertNil(result3.styles)
        XCTAssertEqual(result3.text, "\u{001B}[fg0,0,0;Hello\u{001B}")
    }
    
    func testExtractModes() {
        let result1 = Rainbow.extractModes(for: "\u{001B}[0m\u{001B}[0m")
        XCTAssertNil(result1.color)
        XCTAssertNil(result1.backgroundColor)
        XCTAssertEqual(result1.styles!, [.default])
        XCTAssertEqual(result1.text, "")
        
        let result2 = Rainbow.extractModes(for: "\u{001B}[31mHello World\u{001B}[0m")
        XCTAssertEqual(result2.color!, Color.red)
        XCTAssertNil(result2.backgroundColor)
        XCTAssertNil(result2.styles)
        XCTAssertEqual(result2.text, "Hello World")
        
        let result3 = Rainbow.extractModes(for: "\u{001B}[4;31;42;93;5mHello World\u{001B}[0m")
        XCTAssertEqual(result3.color!, Color.lightYellow)
        XCTAssertEqual(result3.backgroundColor, BackgroundColor.green)
        XCTAssertEqual(result3.styles!, [.underline, .blink])
        XCTAssertEqual(result3.text, "Hello World")
        
        let result4 = Rainbow.extractModes(for: "\u{001B}[31m\u{001B}[4;31;93mHello World\u{001B}[0m\u{001B}[0m")
        XCTAssertEqual(result4.color!, Color.red)
        XCTAssertNil(result4.backgroundColor)
        XCTAssertNil(result4.styles)
        XCTAssertEqual(result4.text, "\u{001B}[4;31;93mHello World\u{001B}[0m")
        
        let result5 = Rainbow.extractModes(for: "\u{001B}[fg0,0,0;Hello\u{001B}[;")
        XCTAssertEqual(result5.color!, Color.black)
        XCTAssertNil(result5.backgroundColor)
        XCTAssertNil(result5.styles)
        XCTAssertEqual(result5.text, "Hello")
        
        let result6 = Rainbow.extractModes(for: "\u{001B}[fg0,0,0;\u{001B}[bg255,0,0;Hello\u{001B}[;")
        XCTAssertEqual(result6.color!, Color.black)
        XCTAssertEqual(result6.backgroundColor, BackgroundColor.red)
        XCTAssertNil(result6.styles)
        XCTAssertEqual(result6.text, "Hello")
    }
    
    func testGenerateConsoleStringWithCodes() {
        
        Rainbow.outputTarget = .console
        
        let result1 = Rainbow.generateString(forColor: nil, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result1, "Hello")
        
        let result2 = Rainbow.generateString(forColor: .red, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result2, "\u{001B}[31mHello\u{001B}[0m")
        
        let result3 = Rainbow.generateString(forColor: .lightYellow, backgroundColor: .magenta, styles: [.bold, .blink], text: "Hello")
        XCTAssertEqual(result3, "\u{001B}[93;45;1;5mHello\u{001B}[0m")
    }
    
    func testGenerateXcodeColorsStringWithCodes() {
        
        Rainbow.outputTarget = .xcodeColors
        
        let result1 = Rainbow.generateString(forColor: nil, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result1, "Hello")
        
        let result2 = Rainbow.generateString(forColor: .red, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result2, "\u{001B}[fg255,0,0;Hello\u{001B}[;")
        
        let result3 = Rainbow.generateString(forColor: .lightYellow, backgroundColor: .magenta, styles: [.bold, .blink], text: "Hello")
        XCTAssertEqual(result3, "\u{001B}[fg255,255,102;\u{001B}[bg255,0,255;Hello\u{001B}[;")
    }
    
    func testGenerateUnknownStringWithCodes() {
        Rainbow.outputTarget = .unknown
        
        let result1 = Rainbow.generateString(forColor: nil, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result1, "Hello")
        
        let result2 = Rainbow.generateString(forColor: .red, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result2, "Hello")
        
        let result3 = Rainbow.generateString(forColor: .lightYellow, backgroundColor: .magenta, styles: [.bold, .blink], text: "Hello")
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
        
        let complex = "\u{001B}[fg255,255,102;\u{001B}[bg255,0,255;Hello\u{001B}[;"
        XCTAssertEqual(complex.raw, "Hello")
        
        let plain = "Hello"
        XCTAssertEqual(plain, "Hello")
    }
}
