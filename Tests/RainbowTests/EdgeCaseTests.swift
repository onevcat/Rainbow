//
//  EdgeCaseTests.swift
//  RainbowTests
//
//  Created by Test Coverage Improvement on 2025-07-15.
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

class EdgeCaseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Rainbow.outputTarget = .console
        Rainbow.enabled = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Empty String Tests
    
    func testEmptyString() {
        let empty = ""
        
        // Empty strings are optimized - no escape sequences are added when text is empty
        XCTAssertEqual(empty.red, "")
        XCTAssertEqual(empty.blue, "")
        XCTAssertEqual(empty.green, "")
        
        // Test background colors
        XCTAssertEqual(empty.onRed, "")
        XCTAssertEqual(empty.onBlue, "")
        
        // Test styles
        XCTAssertEqual(empty.bold, "")
        XCTAssertEqual(empty.italic, "")
        XCTAssertEqual(empty.underline, "")
        
        // Test combinations
        XCTAssertEqual(empty.red.bold.underline, "")
        XCTAssertEqual(empty.green.onYellow.italic, "")
        
        // Test hex colors
        XCTAssertEqual(empty.hex("#FF0000"), "")
        XCTAssertEqual(empty.onHex("#00FF00"), "")
        
        // Test 8-bit and 24-bit colors
        XCTAssertEqual(empty.bit8(123), "")
        XCTAssertEqual(empty.bit24(255, 128, 64), "")
        
        // Test raw property
        XCTAssertEqual(empty.red.raw, "")
        XCTAssertEqual(empty.red.bold.underline.raw, "")
    }
    
    func testEmptyStringWithDisabledRainbow() {
        Rainbow.enabled = false
        let empty = ""
        
        XCTAssertEqual(empty.red, "")
        XCTAssertEqual(empty.bold, "")
        XCTAssertEqual(empty.red.bold.underline, "")
        
        Rainbow.enabled = true
    }
    
    // MARK: - Special Characters Tests
    
    func testSpecialCharacters() {
        let specialChars = "!@#$%^&*()_+-=[]{}|;':\",./<>?"
        
        // Test basic styling
        XCTAssertEqual(specialChars.red, "\u{001B}[31m!@#$%^&*()_+-=[]{}|;':\",./<>?\u{001B}[0m")
        XCTAssertEqual(specialChars.bold, "\u{001B}[1m!@#$%^&*()_+-=[]{}|;':\",./<>?\u{001B}[0m")
        XCTAssertEqual(specialChars.underline, "\u{001B}[4m!@#$%^&*()_+-=[]{}|;':\",./<>?\u{001B}[0m")
        
        // Test combinations
        XCTAssertEqual(specialChars.red.bold, "\u{001B}[31;1m!@#$%^&*()_+-=[]{}|;':\",./<>?\u{001B}[0m")
        XCTAssertEqual(specialChars.blue.onYellow.italic, "\u{001B}[34;43;3m!@#$%^&*()_+-=[]{}|;':\",./<>?\u{001B}[0m")
        
        // Test raw property
        XCTAssertEqual(specialChars.red.raw, specialChars)
        XCTAssertEqual(specialChars.red.bold.underline.raw, specialChars)
    }
    
    func testNewlineCharacters() {
        let newlines = "Line1\nLine2\rLine3\r\nLine4"
        
        XCTAssertEqual(newlines.red, "\u{001B}[31mLine1\nLine2\rLine3\r\nLine4\u{001B}[0m")
        XCTAssertEqual(newlines.bold, "\u{001B}[1mLine1\nLine2\rLine3\r\nLine4\u{001B}[0m")
        XCTAssertEqual(newlines.red.bold.raw, newlines)
    }
    
    func testTabCharacters() {
        let tabs = "Column1\tColumn2\t\tColumn3"
        
        XCTAssertEqual(tabs.blue, "\u{001B}[34mColumn1\tColumn2\t\tColumn3\u{001B}[0m")
        XCTAssertEqual(tabs.onRed.italic, "\u{001B}[41;3mColumn1\tColumn2\t\tColumn3\u{001B}[0m")
        XCTAssertEqual(tabs.blue.raw, tabs)
    }
    
    // MARK: - Unicode Characters Tests
    
    func testUnicodeCharacters() {
        let emoji = "Hello 👋 World 🌍"
        
        XCTAssertEqual(emoji.red, "\u{001B}[31mHello 👋 World 🌍\u{001B}[0m")
        XCTAssertEqual(emoji.bold, "\u{001B}[1mHello 👋 World 🌍\u{001B}[0m")
        XCTAssertEqual(emoji.red.bold.raw, emoji)
    }
    
    func testChineseCharacters() {
        let chinese = "你好世界"
        
        XCTAssertEqual(chinese.green, "\u{001B}[32m你好世界\u{001B}[0m")
        XCTAssertEqual(chinese.onBlue.bold, "\u{001B}[44;1m你好世界\u{001B}[0m")
        XCTAssertEqual(chinese.green.raw, chinese)
    }
    
    func testMixedUnicodeAndASCII() {
        let mixed = "Hello 世界 👋 ASCII"
        
        XCTAssertEqual(mixed.magenta, "\u{001B}[35mHello 世界 👋 ASCII\u{001B}[0m")
        XCTAssertEqual(mixed.cyan.underline, "\u{001B}[36;4mHello 世界 👋 ASCII\u{001B}[0m")
        XCTAssertEqual(mixed.magenta.raw, mixed)
    }
    
    // MARK: - Very Long String Tests
    
    func testVeryLongString() {
        let longString = String(repeating: "Rainbow", count: 1000)
        
        let styled = longString.red.bold
        
        // Should start with escape sequence
        XCTAssertTrue(styled.hasPrefix("\u{001B}[31;1m"))
        
        // Should end with reset sequence
        XCTAssertTrue(styled.hasSuffix("\u{001B}[0m"))
        
        // Should contain the original text
        XCTAssertTrue(styled.contains("Rainbow"))
        
        // Test raw property
        XCTAssertEqual(longString.red.bold.raw, longString)
        
        // Test length is reasonable (original + escape sequences)
        XCTAssertTrue(styled.count > longString.count)
        XCTAssertTrue(styled.count < longString.count + 50) // Should not be too much overhead
    }
    
    func testVeryLongStringWithMultipleStyles() {
        let longString = String(repeating: "Test", count: 500)
        
        let styled = longString.red.bold.underline.italic.onBlue
        
        // Should handle multiple styles correctly (order may vary for multi-segment strings)
        XCTAssertTrue(styled.hasPrefix("\u{001B}["))
        XCTAssertTrue(styled.contains("31")) // red
        XCTAssertTrue(styled.contains("1"))  // bold
        XCTAssertTrue(styled.contains("4"))  // underline
        XCTAssertTrue(styled.contains("3"))  // italic
        XCTAssertTrue(styled.contains("44")) // onBlue
        XCTAssertTrue(styled.hasSuffix("\u{001B}[0m"))
        XCTAssertEqual(styled.raw, longString)
    }
    
    // MARK: - Invalid Input Tests
    
    func testInvalidHexColors() {
        let text = "Test"
        
        // Invalid hex formats should return original string
        XCTAssertEqual(text.hex("invalid"), text)
        XCTAssertEqual(text.hex("#invalid"), text)
        XCTAssertEqual(text.hex("12345"), text)
        XCTAssertEqual(text.hex("#12345"), text)
        XCTAssertEqual(text.hex("1234567"), text)
        XCTAssertEqual(text.hex("#1234567"), text)
        XCTAssertEqual(text.hex("gg0000"), text)
        XCTAssertEqual(text.hex("#gg0000"), text)
        
        // Same for background colors
        XCTAssertEqual(text.onHex("invalid"), text)
        XCTAssertEqual(text.onHex("#invalid"), text)
        XCTAssertEqual(text.onHex("12345"), text)
        
        // Empty hex should return original
        XCTAssertEqual(text.hex(""), text)
        XCTAssertEqual(text.onHex(""), text)
    }
    
    func testInvalidUInt32HexColors() {
        let text = "Test"
        
        // Values out of range should return original string
        XCTAssertEqual(text.hex(0x1000000), text) // > 0xFFFFFF
        XCTAssertEqual(text.onHex(0x1000000), text) // > 0xFFFFFF
        
        // Valid values should work
        XCTAssertEqual(text.hex(0x000000), "\u{001B}[38;5;16mTest\u{001B}[0m")
        XCTAssertEqual(text.hex(0xFFFFFF), "\u{001B}[38;5;231mTest\u{001B}[0m")
    }
    
    // MARK: - Single Character Tests
    
    func testSingleCharacter() {
        let single = "A"
        
        XCTAssertEqual(single.red, "\u{001B}[31mA\u{001B}[0m")
        XCTAssertEqual(single.bold, "\u{001B}[1mA\u{001B}[0m")
        XCTAssertEqual(single.red.bold.underline, "\u{001B}[31;1;4mA\u{001B}[0m")
        XCTAssertEqual(single.red.raw, single)
    }
    
    func testSingleUnicodeCharacter() {
        let emoji = "👋"
        
        XCTAssertEqual(emoji.green, "\u{001B}[32m👋\u{001B}[0m")
        XCTAssertEqual(emoji.onBlue.bold, "\u{001B}[44;1m👋\u{001B}[0m")
        XCTAssertEqual(emoji.green.raw, emoji)
    }
    
    // MARK: - Whitespace Tests
    
    func testWhitespaceOnly() {
        let spaces = "   "
        let tabs = "\t\t\t"
        let mixed = " \t \t "
        
        XCTAssertEqual(spaces.red, "\u{001B}[31m   \u{001B}[0m")
        XCTAssertEqual(tabs.bold, "\u{001B}[1m\t\t\t\u{001B}[0m")
        XCTAssertEqual(mixed.blue.underline, "\u{001B}[34;4m \t \t \u{001B}[0m")
        
        XCTAssertEqual(spaces.red.raw, spaces)
        XCTAssertEqual(tabs.bold.raw, tabs)
        XCTAssertEqual(mixed.blue.raw, mixed)
    }
    
    // MARK: - Boundary Value Tests
    
    func testBoundaryBitValues() {
        let text = "Test"
        
        // Test boundary values for 8-bit colors
        XCTAssertEqual(text.bit8(0), "\u{001B}[38;5;0mTest\u{001B}[0m")
        XCTAssertEqual(text.bit8(255), "\u{001B}[38;5;255mTest\u{001B}[0m")
        
        XCTAssertEqual(text.onBit8(0), "\u{001B}[48;5;0mTest\u{001B}[0m")
        XCTAssertEqual(text.onBit8(255), "\u{001B}[48;5;255mTest\u{001B}[0m")
        
        // Test boundary values for 24-bit colors
        XCTAssertEqual(text.bit24(0, 0, 0), "\u{001B}[38;2;0;0;0mTest\u{001B}[0m")
        XCTAssertEqual(text.bit24(255, 255, 255), "\u{001B}[38;2;255;255;255mTest\u{001B}[0m")
        
        XCTAssertEqual(text.onBit24(0, 0, 0), "\u{001B}[48;2;0;0;0mTest\u{001B}[0m")
        XCTAssertEqual(text.onBit24(255, 255, 255), "\u{001B}[48;2;255;255;255mTest\u{001B}[0m")
    }
}