//
//  XcodeColorsStringTests.swift
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

class XcodeColorsStringTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Rainbow.outputTarget = .xcodeColors
        Rainbow.enabled = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testStringColor() {
        let string = "Hello Rainbow"
        XCTAssertEqual(string.black, "\u{001B}[fg0,0,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.red, "\u{001B}[fg255,0,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.green, "\u{001B}[fg0,204,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.yellow, "\u{001B}[fg255,255,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.blue, "\u{001B}[fg0,0,255;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.magenta, "\u{001B}[fg255,0,255;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.cyan, "\u{001B}[fg0,255,255;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.white, "\u{001B}[fg204,204,204;Hello Rainbow\u{001B}[;")
        
        XCTAssertEqual(string.lightBlack, "\u{001B}[fg128,128,128;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.lightRed, "\u{001B}[fg255,102,102;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.lightGreen, "\u{001B}[fg102,255,102;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.lightYellow, "\u{001B}[fg255,255,102;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.lightBlue, "\u{001B}[fg102,102,255;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.lightMagenta, "\u{001B}[fg255,102,255;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.lightCyan, "\u{001B}[fg102,255,255;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.lightWhite, "\u{001B}[fg255,255,255;Hello Rainbow\u{001B}[;")
    }
    
    func testStringBackgroundColor() {
        let string = "Hello Rainbow"
        XCTAssertEqual(string.onBlack, "\u{001B}[bg0,0,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.onRed, "\u{001B}[bg255,0,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.onGreen, "\u{001B}[bg0,204,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.onYellow, "\u{001B}[bg255,255,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.onBlue, "\u{001B}[bg0,0,255;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.onMagenta, "\u{001B}[bg255,0,255;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.onCyan, "\u{001B}[bg0,255,255;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.onWhite, "\u{001B}[bg204,204,204;Hello Rainbow\u{001B}[;")
    }
    
    func testStringStyle() {
        let string = "Hello Rainbow"
        XCTAssertEqual(string.bold, "Hello Rainbow")
        XCTAssertEqual(string.dim, "Hello Rainbow")
        XCTAssertEqual(string.italic, "Hello Rainbow")
        XCTAssertEqual(string.underline, "Hello Rainbow")
        XCTAssertEqual(string.blink, "Hello Rainbow")
        XCTAssertEqual(string.swap, "Hello Rainbow")
    }
    
    func testStringMultipleModes() {
        let string = "Hello Rainbow"
        XCTAssertEqual(string.red.onYellow, "\u{001B}[fg255,0,0;\u{001B}[bg255,255,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.onYellow.red, "\u{001B}[fg255,0,0;\u{001B}[bg255,255,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.green.bold, "\u{001B}[fg0,204,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.onWhite.dim.blink, "\u{001B}[bg204,204,204;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.red.blue.onWhite, "\u{001B}[fg0,0,255;\u{001B}[bg204,204,204;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.red.blue.green.blue.blue, "\u{001B}[fg0,0,255;Hello Rainbow\u{001B}[;")
    }
    
    func testStringClearMode() {
        let string = "Hello Rainbow"
        XCTAssertEqual(string.red.clearColor, "Hello Rainbow")
        XCTAssertEqual(string.onYellow.clearBackgroundColor, "Hello Rainbow")
        XCTAssertEqual(string.red.clearBackgroundColor, "\u{001B}[fg255,0,0;Hello Rainbow\u{001B}[;")
        
        XCTAssertEqual(string.bold.clearStyles, "Hello Rainbow")
        XCTAssertEqual(string.bold.clearColor, "Hello Rainbow")
        XCTAssertEqual(string.red.clearStyles, "\u{001B}[fg255,0,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.red.bold.clearStyles, "\u{001B}[fg255,0,0;Hello Rainbow\u{001B}[;")
        XCTAssertEqual(string.bold.italic.clearStyles, "Hello Rainbow")
    }
}
