//
//  ConsoleStringTests.swift
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

import XCTest
import Rainbow

class ConsoleStringTests: XCTestCase {

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

    func testStringColor() {
        let string = "Hello Rainbow"
        XCTAssertEqual(string.black, "\u{001B}[30mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.red, "\u{001B}[31mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.green, "\u{001B}[32mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.yellow, "\u{001B}[33mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.blue, "\u{001B}[34mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.magenta, "\u{001B}[35mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.cyan, "\u{001B}[36mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.white, "\u{001B}[37mHello Rainbow\u{001B}[0m")
        
        XCTAssertEqual(string.lightBlack, "\u{001B}[90mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.lightRed, "\u{001B}[91mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.lightGreen, "\u{001B}[92mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.lightYellow, "\u{001B}[93mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.lightBlue, "\u{001B}[94mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.lightMagenta, "\u{001B}[95mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.lightCyan, "\u{001B}[96mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.lightWhite, "\u{001B}[97mHello Rainbow\u{001B}[0m")
    }

    func testStringBackgroundColor() {
        let string = "Hello Rainbow"
        XCTAssertEqual(string.onBlack, "\u{001B}[40mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.onRed, "\u{001B}[41mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.onGreen, "\u{001B}[42mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.onYellow, "\u{001B}[43mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.onBlue, "\u{001B}[44mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.onMagenta, "\u{001B}[45mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.onCyan, "\u{001B}[46mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.onWhite, "\u{001B}[47mHello Rainbow\u{001B}[0m")
    }
    
    func testStringStyle() {
        let string = "Hello Rainbow"
        XCTAssertEqual(string.bold, "\u{001B}[1mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.dim, "\u{001B}[2mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.italic, "\u{001B}[3mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.underline, "\u{001B}[4mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.blink, "\u{001B}[5mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.swap, "\u{001B}[7mHello Rainbow\u{001B}[0m")
    }
    
    func testStringMultipleModes() {
        let string = "Hello Rainbow"
        XCTAssertEqual(string.red.onYellow, "\u{001B}[31;43mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.onYellow.red, "\u{001B}[31;43mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.green.bold, "\u{001B}[32;1mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.onWhite.dim.blink, "\u{001B}[47;2;5mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.red.blue.onWhite, "\u{001B}[34;47mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.red.blue.green.blue.blue, "\u{001B}[34mHello Rainbow\u{001B}[0m")
    }
    
    func testStringClearMode() {
        let string = "Hello Rainbow"
        XCTAssertEqual(string.red.clearColor, "\u{001B}[39mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.onYellow.clearBackgroundColor, "\u{001B}[49mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.red.clearBackgroundColor, "\u{001B}[31mHello Rainbow\u{001B}[0m")

        XCTAssertEqual(string.bold.clearStyles, "Hello Rainbow")
        XCTAssertEqual(string.bold.clearColor, "\u{001B}[1mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.red.clearStyles, "\u{001B}[31mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.red.bold.clearStyles, "\u{001B}[31mHello Rainbow\u{001B}[0m")
        XCTAssertEqual(string.bold.italic.clearStyles, "Hello Rainbow")
    }
}
