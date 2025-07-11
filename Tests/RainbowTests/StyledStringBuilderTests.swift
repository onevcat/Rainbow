//
//  StyledStringBuilderTests.swift
//  RainbowTests
//
//  Created by Performance Optimization on 2025-07-11.
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

class StyledStringBuilderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Rainbow.outputTarget = .console
        Rainbow.enabled = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Basic Color Tests
    
    func testBasicColors() {
        let text = "Hello World"
        
        // Test each basic color
        XCTAssertEqual(text.styled.red.build(), text.red)
        XCTAssertEqual(text.styled.green.build(), text.green)
        XCTAssertEqual(text.styled.blue.build(), text.blue)
        XCTAssertEqual(text.styled.yellow.build(), text.yellow)
        XCTAssertEqual(text.styled.magenta.build(), text.magenta)
        XCTAssertEqual(text.styled.cyan.build(), text.cyan)
        XCTAssertEqual(text.styled.white.build(), text.white)
        XCTAssertEqual(text.styled.black.build(), text.black)
    }
    
    func testLightColors() {
        let text = "Test"
        
        XCTAssertEqual(text.styled.lightRed.build(), text.lightRed)
        XCTAssertEqual(text.styled.lightGreen.build(), text.lightGreen)
        XCTAssertEqual(text.styled.lightBlue.build(), text.lightBlue)
        XCTAssertEqual(text.styled.lightYellow.build(), text.lightYellow)
        XCTAssertEqual(text.styled.lightMagenta.build(), text.lightMagenta)
        XCTAssertEqual(text.styled.lightCyan.build(), text.lightCyan)
        XCTAssertEqual(text.styled.lightWhite.build(), text.lightWhite)
        XCTAssertEqual(text.styled.lightBlack.build(), text.lightBlack)
    }
    
    // MARK: - Background Color Tests
    
    func testBasicBackgroundColors() {
        let text = "Background Test"
        
        XCTAssertEqual(text.styled.onRed.build(), text.onRed)
        XCTAssertEqual(text.styled.onGreen.build(), text.onGreen)
        XCTAssertEqual(text.styled.onBlue.build(), text.onBlue)
        XCTAssertEqual(text.styled.onYellow.build(), text.onYellow)
        XCTAssertEqual(text.styled.onMagenta.build(), text.onMagenta)
        XCTAssertEqual(text.styled.onCyan.build(), text.onCyan)
        XCTAssertEqual(text.styled.onWhite.build(), text.onWhite)
        XCTAssertEqual(text.styled.onBlack.build(), text.onBlack)
    }
    
    func testLightBackgroundColors() {
        let text = "Light Background"
        
        XCTAssertEqual(text.styled.onLightRed.build(), text.onLightRed)
        XCTAssertEqual(text.styled.onLightGreen.build(), text.onLightGreen)
        XCTAssertEqual(text.styled.onLightBlue.build(), text.onLightBlue)
        XCTAssertEqual(text.styled.onLightYellow.build(), text.onLightYellow)
        XCTAssertEqual(text.styled.onLightMagenta.build(), text.onLightMagenta)
        XCTAssertEqual(text.styled.onLightCyan.build(), text.onLightCyan)
        XCTAssertEqual(text.styled.onLightWhite.build(), text.onLightWhite)
        XCTAssertEqual(text.styled.onLightBlack.build(), text.onLightBlack)
    }
    
    // MARK: - Style Tests
    
    func testBasicStyles() {
        let text = "Style Test"
        
        XCTAssertEqual(text.styled.bold.build(), text.bold)
        XCTAssertEqual(text.styled.dim.build(), text.dim)
        XCTAssertEqual(text.styled.italic.build(), text.italic)
        XCTAssertEqual(text.styled.underline.build(), text.underline)
        XCTAssertEqual(text.styled.blink.build(), text.blink)
        XCTAssertEqual(text.styled.swap.build(), text.swap)
    }
    
    // MARK: - Chained Operations Tests
    
    func testSimpleChaining() {
        let text = "Chain Test"
        
        // Two properties
        XCTAssertEqual(text.styled.red.bold.build(), text.red.bold)
        XCTAssertEqual(text.styled.green.underline.build(), text.green.underline)
        XCTAssertEqual(text.styled.blue.onYellow.build(), text.blue.onYellow)
    }
    
    func testComplexChaining() {
        let text = "Complex Chain"
        
        // Multiple properties
        XCTAssertEqual(
            text.styled.red.bold.underline.build(),
            text.red.bold.underline
        )
        
        XCTAssertEqual(
            text.styled.green.italic.onBlue.build(),
            text.green.italic.onBlue
        )
        
        XCTAssertEqual(
            text.styled.yellow.bold.underline.onMagenta.build(),
            text.yellow.bold.underline.onMagenta
        )
    }
    
    func testVeryComplexChaining() {
        let text = "Very Complex"
        
        // All types of properties
        XCTAssertEqual(
            text.styled.red.bold.underline.italic.onBlue.build(),
            text.red.bold.underline.italic.onBlue
        )
        
        XCTAssertEqual(
            text.styled.lightGreen.dim.blink.swap.onLightMagenta.build(),
            text.lightGreen.dim.blink.swap.onLightMagenta
        )
    }
    
    // MARK: - Advanced Color Tests
    
    func testBit8Colors() {
        let text = "8-bit Color"
        
        XCTAssertEqual(text.styled.bit8(31).build(), text.bit8(31))
        XCTAssertEqual(text.styled.bit8(196).build(), text.bit8(196))
        XCTAssertEqual(text.styled.bit8(0).build(), text.bit8(0))
        XCTAssertEqual(text.styled.bit8(255).build(), text.bit8(255))
    }
    
    func testBit24Colors() {
        let text = "24-bit Color"
        
        XCTAssertEqual(text.styled.bit24(255, 128, 64).build(), text.bit24(255, 128, 64))
        XCTAssertEqual(text.styled.bit24(0, 0, 0).build(), text.bit24(0, 0, 0))
        XCTAssertEqual(text.styled.bit24(255, 255, 255).build(), text.bit24(255, 255, 255))
        
        // Test RGB tuple version
        let rgb: RGB = (128, 64, 192)
        XCTAssertEqual(text.styled.bit24(rgb).build(), text.bit24(rgb))
    }
    
    func testHexColors() {
        let text = "Hex Color"
        
        XCTAssertEqual(text.styled.hex("#FF0000").build(), text.hex("#FF0000"))
        XCTAssertEqual(text.styled.hex("00FF00").build(), text.hex("00FF00"))
        XCTAssertEqual(text.styled.hex("#F0F").build(), text.hex("#F0F"))
        
        // Test with different targets
        XCTAssertEqual(
            text.styled.hex("#FF0000", to: .bit24).build(),
            text.hex("#FF0000", to: .bit24)
        )
        
        // Test UInt32 version
        XCTAssertEqual(text.styled.hex(0xFF0000).build(), text.hex(0xFF0000))
        XCTAssertEqual(
            text.styled.hex(0x00FF00, to: .bit24).build(),
            text.hex(0x00FF00, to: .bit24)
        )
    }
    
    func testAdvancedBackgroundColors() {
        let text = "Advanced BG"
        
        XCTAssertEqual(text.styled.onBit8(196).build(), text.onBit8(196))
        XCTAssertEqual(text.styled.onBit24(255, 128, 64).build(), text.onBit24(255, 128, 64))
        
        let rgb: RGB = (64, 128, 255)
        XCTAssertEqual(text.styled.onBit24(rgb).build(), text.onBit24(rgb))
        
        XCTAssertEqual(text.styled.onHex("#FF0000").build(), text.onHex("#FF0000"))
        XCTAssertEqual(
            text.styled.onHex("00FF00", to: .bit24).build(),
            text.onHex("00FF00", to: .bit24)
        )
        
        XCTAssertEqual(text.styled.onHex(0xFF0000).build(), text.onHex(0xFF0000))
    }
    
    // MARK: - Complex Combinations
    
    func testColorAndBackgroundCombinations() {
        let text = "Color + BG"
        
        XCTAssertEqual(
            text.styled.red.onBlue.build(),
            text.red.onBlue
        )
        
        XCTAssertEqual(
            text.styled.bit8(196).onBit8(21).build(),
            text.bit8(196).onBit8(21)
        )
        
        XCTAssertEqual(
            text.styled.hex("#FF0000").onHex("#0000FF").build(),
            text.hex("#FF0000").onHex("#0000FF")
        )
    }
    
    func testColorBackgroundAndStyleCombinations() {
        let text = "Full Combo"
        
        XCTAssertEqual(
            text.styled.red.onBlue.bold.underline.build(),
            text.red.onBlue.bold.underline
        )
        
        XCTAssertEqual(
            text.styled.bit24(255, 128, 64).onBit8(21).italic.blink.build(),
            text.bit24(255, 128, 64).onBit8(21).italic.blink
        )
        
        XCTAssertEqual(
            text.styled.hex("#FF0000").onHex("#0000FF").bold.underline.italic.build(),
            text.hex("#FF0000").onHex("#0000FF").bold.underline.italic
        )
    }
    
    // MARK: - Edge Cases
    
    func testEmptyString() {
        let text = ""
        
        XCTAssertEqual(text.styled.red.build(), text.red)
        XCTAssertEqual(text.styled.red.bold.underline.build(), text.red.bold.underline)
    }
    
    func testSingleCharacter() {
        let text = "A"
        
        XCTAssertEqual(text.styled.red.build(), text.red)
        XCTAssertEqual(text.styled.green.bold.build(), text.green.bold)
    }
    
    func testLongString() {
        let text = String(repeating: "Long text string for testing purposes. ", count: 100)
        
        XCTAssertEqual(text.styled.red.bold.underline.build(), text.red.bold.underline)
    }
    
    func testSpecialCharacters() {
        let text = "Special: 🌈 测试 עברית العربية"
        
        XCTAssertEqual(text.styled.red.build(), text.red)
        XCTAssertEqual(text.styled.green.bold.onYellow.build(), text.green.bold.onYellow)
    }
    
    // MARK: - Batch Operations Tests
    
    func testBatchOperations() {
        let text = "Batch Test"
        
        // Test applyingMultipleStyles
        let builderResult = text.styled.applyingMultipleStyles([.bold, .underline, .italic]).build()
        let traditionalResult = text.applyingStyles([.bold, .underline, .italic])
        XCTAssertEqual(builderResult, traditionalResult)
        
        // Test applyingAll
        let builderAll = text.styled.applyingAll(
            color: .named(.red),
            backgroundColor: .named(.blue),
            styles: [.bold, .underline]
        ).build()
        let traditionalAll = text.applyingAll(
            color: .named(.red),
            backgroundColor: .named(.blue),
            styles: [.bold, .underline]
        )
        XCTAssertEqual(builderAll, traditionalAll)
    }
    
    // MARK: - Rainbow State Tests
    
    func testRainbowDisabled() {
        let text = "Disabled Test"
        
        Rainbow.enabled = false
        
        XCTAssertEqual(text.styled.red.bold.build(), text)
        XCTAssertEqual(text.styled.green.onBlue.underline.build(), text)
        
        Rainbow.enabled = true
    }
    
    func testRainbowUnknownTarget() {
        let text = "Unknown Target"
        let originalTarget = Rainbow.outputTarget
        
        Rainbow.outputTarget = .unknown
        
        XCTAssertEqual(text.styled.red.bold.build(), text)
        XCTAssertEqual(text.styled.green.onBlue.underline.build(), text)
        
        Rainbow.outputTarget = originalTarget
    }
    
    // MARK: - Custom String Convertible Tests
    
    func testCustomStringConvertible() {
        let text = "Convertible Test"
        
        let builder = text.styled.red.bold
        let built = builder.build()
        let description = builder.description
        
        XCTAssertEqual(built, description)
        XCTAssertEqual(description, text.red.bold)
    }
    
    // MARK: - Plain Text Property Tests
    
    func testPlainTextProperty() {
        let text = "Plain Text Test"
        
        let builder = text.styled.red.bold.underline.onBlue
        XCTAssertEqual(builder.plainText, text)
        
        // Test that plainText is not affected by styling
        XCTAssertEqual(builder.plainText, text)
        XCTAssertNotEqual(builder.build(), text)
    }
    
    // MARK: - Equatable Tests
    
    func testEquatable() {
        let text = "Equatable Test"
        
        let builder1 = text.styled.red.bold
        let builder2 = text.styled.red.bold
        let builder3 = text.styled.blue.bold
        let builder4 = text.styled.red.italic
        
        XCTAssertEqual(builder1, builder2)
        XCTAssertNotEqual(builder1, builder3)
        XCTAssertNotEqual(builder1, builder4)
        XCTAssertNotEqual(builder3, builder4)
    }
    
    // MARK: - Consistent Ordering Tests
    
    func testConsistentOrdering() {
        let text = "Order Test"
        
        // Builder pattern should maintain consistent internal ordering
        let result1 = text.styled.red.bold.underline.build()
        let result2 = text.styled.red.bold.underline.build()
        
        // Same builder calls should produce identical results
        XCTAssertEqual(result1, result2)
        
        // Should match traditional chaining in the same order
        XCTAssertEqual(result1, text.red.bold.underline)
        
        // Different orders may produce different ANSI codes but that's expected
        // since ANSI code order can affect appearance in some terminals
        let differentOrder = text.styled.bold.red.underline.build()
        let traditionalDifferentOrder = text.bold.red.underline
        XCTAssertEqual(differentOrder, traditionalDifferentOrder)
    }
    
    // MARK: - Invalid Hex Color Tests
    
    func testInvalidHexColors() {
        let text = "Invalid Hex"
        
        // Invalid hex colors should return the original string (same as traditional API)
        XCTAssertEqual(text.styled.hex("invalid").build(), text.hex("invalid"))
        XCTAssertEqual(text.styled.hex("#GGGGGG").build(), text.hex("#GGGGGG"))
        XCTAssertEqual(text.styled.hex("").build(), text.hex(""))
    }
}