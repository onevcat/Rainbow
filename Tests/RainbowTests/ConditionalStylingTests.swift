//
//  ConditionalStylingTests.swift
//  RainbowTests
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
@testable import Rainbow

class ConditionalStylingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Rainbow.enabled = true
        Rainbow.outputTarget = .console
    }
    
    override func tearDown() {
        super.tearDown()
        Rainbow.enabled = true
    }
    
    // MARK: - Basic Conditional Color Tests
    
    func testColorIfTrue() {
        let text = "Hello"
        let result = text.colorIf(true, .red)
        XCTAssertEqual(result, "\u{001B}[31mHello\u{001B}[0m")
    }
    
    func testColorIfFalse() {
        let text = "Hello"
        let result = text.colorIf(false, .red)
        XCTAssertEqual(result, "Hello")
    }
    
    func testColorTypeIfTrue() {
        let text = "Hello"
        let result = text.colorIf(true, .bit24((255, 0, 0)))
        XCTAssertEqual(result, "\u{001B}[38;2;255;0;0mHello\u{001B}[0m")
    }
    
    func testColorTypeIfFalse() {
        let text = "Hello"
        let result = text.colorIf(false, .bit24((255, 0, 0)))
        XCTAssertEqual(result, "Hello")
    }
    
    func testColorWhenTrue() {
        let text = "Hello"
        let condition = { true }
        let result = text.colorWhen(condition, .green)
        XCTAssertEqual(result, "\u{001B}[32mHello\u{001B}[0m")
    }
    
    func testColorWhenFalse() {
        let text = "Hello"
        let condition = { false }
        let result = text.colorWhen(condition, .green)
        XCTAssertEqual(result, "Hello")
    }
    
    // MARK: - Conditional Background Color Tests
    
    func testBackgroundColorIfTrue() {
        let text = "Hello"
        let result = text.backgroundColorIf(true, .red)
        XCTAssertEqual(result, "\u{001B}[41mHello\u{001B}[0m")
    }
    
    func testBackgroundColorIfFalse() {
        let text = "Hello"
        let result = text.backgroundColorIf(false, .red)
        XCTAssertEqual(result, "Hello")
    }
    
    func testBackgroundColorTypeIfTrue() {
        let text = "Hello"
        let result = text.backgroundColorIf(true, .bit24((0, 255, 0)))
        XCTAssertEqual(result, "\u{001B}[48;2;0;255;0mHello\u{001B}[0m")
    }
    
    func testBackgroundColorWhenTrue() {
        let text = "Hello"
        let condition = { true }
        let result = text.backgroundColorWhen(condition, .blue)
        XCTAssertEqual(result, "\u{001B}[44mHello\u{001B}[0m")
    }
    
    // MARK: - Conditional Style Tests
    
    func testStyleIfTrue() {
        let text = "Hello"
        let result = text.styleIf(true, .bold)
        XCTAssertEqual(result, "\u{001B}[1mHello\u{001B}[0m")
    }
    
    func testStyleIfFalse() {
        let text = "Hello"
        let result = text.styleIf(false, .bold)
        XCTAssertEqual(result, "Hello")
    }
    
    func testStylesIfTrue() {
        let text = "Hello"
        let result = text.stylesIf(true, [.bold, .underline])
        XCTAssertEqual(result, "\u{001B}[1;4mHello\u{001B}[0m")
    }
    
    func testStylesIfFalse() {
        let text = "Hello"
        let result = text.stylesIf(false, [.bold, .underline])
        XCTAssertEqual(result, "Hello")
    }
    
    func testStyleWhenTrue() {
        let text = "Hello"
        let condition = { true }
        let result = text.styleWhen(condition, .italic)
        XCTAssertEqual(result, "\u{001B}[3mHello\u{001B}[0m")
    }
    
    // MARK: - General Conditional Application Tests
    
    func testApplyIfTrue() {
        let text = "Hello"
        let result = text.applyIf(true) { $0.red.bold }
        XCTAssertEqual(result, "\u{001B}[31;1mHello\u{001B}[0m")
    }
    
    func testApplyIfFalse() {
        let text = "Hello"
        let result = text.applyIf(false) { $0.red.bold }
        XCTAssertEqual(result, "Hello")
    }
    
    func testApplyWhenTrue() {
        let text = "Hello"
        let condition = { true }
        let result = text.applyWhen(condition) { $0.green.underline }
        XCTAssertEqual(result, "\u{001B}[32;4mHello\u{001B}[0m")
    }
    
    // MARK: - Chaining Tests
    
    func testChainingMultipleConditions() {
        let text = "Status"
        let isError = true
        let isImportant = true
        let isUrgent = false
        
        let result = text
            .colorIf(isError, .red)
            .styleIf(isImportant, .bold)
            .styleIf(isUrgent, .underline)
        
        XCTAssertEqual(result, "\u{001B}[31;1mStatus\u{001B}[0m")
    }
    
    func testChainingMixedConditions() {
        let text = "Message"
        let showColor = true
        let showBackground = false
        let showStyle = true
        
        let result = text
            .colorIf(showColor, .yellow)
            .backgroundColorIf(showBackground, .blue)
            .styleIf(showStyle, .italic)
        
        XCTAssertEqual(result, "\u{001B}[33;3mMessage\u{001B}[0m")
    }
    
    // MARK: - ConditionalStyleBuilder Tests
    
    func testBuilderSingleConditionTrue() {
        let text = "Hello"
        let result = text
            .conditionalStyled
            .when(true).red
            .build()
        
        XCTAssertEqual(result, "\u{001B}[31mHello\u{001B}[0m")
    }
    
    func testBuilderSingleConditionFalse() {
        let text = "Hello"
        let result = text
            .conditionalStyled
            .when(false).red
            .build()
        
        XCTAssertEqual(result, "Hello")
    }
    
    func testBuilderMultipleConditions() {
        let text = "Status"
        let isActive = true
        let isWarning = false
        let isError = false
        
        let result = text
            .conditionalStyled
            .when(isActive).green.bold
            .when(isWarning).yellow
            .when(isError).red.underline
            .build()
        
        XCTAssertEqual(result, "\u{001B}[32;1mStatus\u{001B}[0m")
    }
    
    func testBuilderWithClosurePredicate() {
        let text = "Value"
        let value = 42
        
        let result = text
            .conditionalStyled
            .when { value > 40 }.green
            .when({ value > 100 }).bold
            .build()
        
        XCTAssertEqual(result, "\u{001B}[32mValue\u{001B}[0m")
    }
    
    func testBuilderWithCustomTransform() {
        let text = "Custom"
        let result = text
            .conditionalStyled
            .when(true).transform { $0.red.bold.underline }
            .build()
        
        XCTAssertEqual(result, "\u{001B}[31;1;4mCustom\u{001B}[0m")
    }
    
    func testBuilderWithBackgroundColor() {
        let text = "Background"
        let result = text
            .conditionalStyled
            .when(true).backgroundColor(.yellow)
            .build()
        
        XCTAssertEqual(result, "\u{001B}[43mBackground\u{001B}[0m")
    }
    
    func testBuilderWithMultipleStyles() {
        let text = "Multiple"
        let result = text
            .conditionalStyled
            .when(true).styles(.bold, .italic, .underline)
            .build()
        
        XCTAssertEqual(result, "\u{001B}[1;3;4mMultiple\u{001B}[0m")
    }
    
    func testBuilderWithColorAndStyles() {
        let text = "Combined"
        let result = text
            .conditionalStyled
            .when(true).red.bold.underline
            .build()
        
        XCTAssertEqual(result, "\u{001B}[31;1;4mCombined\u{001B}[0m")
    }
    
    // MARK: - Rainbow Disabled Tests
    
    func testConditionalStylingWhenRainbowDisabled() {
        Rainbow.enabled = false
        
        let text = "Hello"
        XCTAssertEqual(text.colorIf(true, .red), "Hello")
        XCTAssertEqual(text.styleIf(true, .bold), "Hello")
        XCTAssertEqual(text.backgroundColorIf(true, .blue), "Hello")
        XCTAssertEqual(text.applyIf(true) { $0.green }, "Hello")
        
        let builderResult = text
            .conditionalStyled
            .when(true).red
            .build()
        XCTAssertEqual(builderResult, "Hello")
    }
    
    // MARK: - Edge Cases
    
    func testEmptyStringConditionalStyling() {
        let text = ""
        XCTAssertEqual(text.colorIf(true, .red), "")
        XCTAssertEqual(text.colorIf(false, .red), "")
    }
    
    func testConditionalStylingWithExistingStyles() {
        let text = "Hello".red
        let result = text.styleIf(true, .bold)
        XCTAssertEqual(result, "\u{001B}[31;1mHello\u{001B}[0m")
    }
    
    func testBuilderWithNoConditions() {
        let text = "Plain"
        let result = text.conditionalStyled.build()
        XCTAssertEqual(result, "Plain")
    }
}
