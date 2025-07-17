//
//  HSLColorTests.swift
//  Rainbow
//
//  Created by Rainbow on 16/7/25.
//

import XCTest
@testable import Rainbow

class HSLColorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Rainbow.outputTarget = .console
        Rainbow.enabled = true
    }
    
    func testHSLToRGBConversion() {
        // Test pure colors
        let redConverter = HSLColorConverter(hue: 0, saturation: 100, lightness: 50)
        let redRGB = redConverter.toRGB()
        XCTAssertEqual(redRGB.0, 255)
        XCTAssertEqual(redRGB.1, 0)
        XCTAssertEqual(redRGB.2, 0)
        
        let greenConverter = HSLColorConverter(hue: 120, saturation: 100, lightness: 50)
        let greenRGB = greenConverter.toRGB()
        XCTAssertEqual(greenRGB.0, 0)
        XCTAssertEqual(greenRGB.1, 255)
        XCTAssertEqual(greenRGB.2, 0)
        
        let blueConverter = HSLColorConverter(hue: 240, saturation: 100, lightness: 50)
        let blueRGB = blueConverter.toRGB()
        XCTAssertEqual(blueRGB.0, 0)
        XCTAssertEqual(blueRGB.1, 0)
        XCTAssertEqual(blueRGB.2, 255)
        
        // Test grayscale (saturation = 0)
        let grayConverter = HSLColorConverter(hue: 0, saturation: 0, lightness: 50)
        let grayRGB = grayConverter.toRGB()
        XCTAssertEqual(grayRGB.0, 128)
        XCTAssertEqual(grayRGB.1, 128)
        XCTAssertEqual(grayRGB.2, 128)
        
        let blackConverter = HSLColorConverter(hue: 0, saturation: 0, lightness: 0)
        let blackRGB = blackConverter.toRGB()
        XCTAssertEqual(blackRGB.0, 0)
        XCTAssertEqual(blackRGB.1, 0)
        XCTAssertEqual(blackRGB.2, 0)
        
        let whiteConverter = HSLColorConverter(hue: 0, saturation: 0, lightness: 100)
        let whiteRGB = whiteConverter.toRGB()
        XCTAssertEqual(whiteRGB.0, 255)
        XCTAssertEqual(whiteRGB.1, 255)
        XCTAssertEqual(whiteRGB.2, 255)
        
        // Test intermediate colors
        let orangeConverter = HSLColorConverter(hue: 30, saturation: 100, lightness: 50)
        let orangeRGB = orangeConverter.toRGB()
        XCTAssertEqual(orangeRGB.0, 255)
        XCTAssertEqual(orangeRGB.1, 128)
        XCTAssertEqual(orangeRGB.2, 0)
        
        let purpleConverter = HSLColorConverter(hue: 270, saturation: 50, lightness: 50)
        let purpleRGB = purpleConverter.toRGB()
        XCTAssertEqual(purpleRGB.0, 127)
        XCTAssertEqual(purpleRGB.1, 64)
        XCTAssertEqual(purpleRGB.2, 191)
    }
    
    func testHSLNormalization() {
        // Test hue wrapping
        let converter1 = HSLColorConverter(hue: 380, saturation: 100, lightness: 50)
        let converter2 = HSLColorConverter(hue: 20, saturation: 100, lightness: 50)
        let rgb1 = converter1.toRGB()
        let rgb2 = converter2.toRGB()
        XCTAssertEqual(rgb1.0, rgb2.0)
        XCTAssertEqual(rgb1.1, rgb2.1)
        XCTAssertEqual(rgb1.2, rgb2.2)
        
        let converter3 = HSLColorConverter(hue: -20, saturation: 100, lightness: 50)
        let converter4 = HSLColorConverter(hue: 340, saturation: 100, lightness: 50)
        let rgb3 = converter3.toRGB()
        let rgb4 = converter4.toRGB()
        XCTAssertEqual(rgb3.0, rgb4.0)
        XCTAssertEqual(rgb3.1, rgb4.1)
        XCTAssertEqual(rgb3.2, rgb4.2)
        
        // Test saturation clamping
        let converter5 = HSLColorConverter(hue: 0, saturation: 150, lightness: 50)
        let converter6 = HSLColorConverter(hue: 0, saturation: 100, lightness: 50)
        let rgb5 = converter5.toRGB()
        let rgb6 = converter6.toRGB()
        XCTAssertEqual(rgb5.0, rgb6.0)
        XCTAssertEqual(rgb5.1, rgb6.1)
        XCTAssertEqual(rgb5.2, rgb6.2)
        
        let converter7 = HSLColorConverter(hue: 0, saturation: -50, lightness: 50)
        let converter8 = HSLColorConverter(hue: 0, saturation: 0, lightness: 50)
        let rgb7 = converter7.toRGB()
        let rgb8 = converter8.toRGB()
        XCTAssertEqual(rgb7.0, rgb8.0)
        XCTAssertEqual(rgb7.1, rgb8.1)
        XCTAssertEqual(rgb7.2, rgb8.2)
        
        // Test lightness clamping
        let converter9 = HSLColorConverter(hue: 0, saturation: 100, lightness: 150)
        let converter10 = HSLColorConverter(hue: 0, saturation: 100, lightness: 100)
        let rgb9 = converter9.toRGB()
        let rgb10 = converter10.toRGB()
        XCTAssertEqual(rgb9.0, rgb10.0)
        XCTAssertEqual(rgb9.1, rgb10.1)
        XCTAssertEqual(rgb9.2, rgb10.2)
    }
    
    func testStringHSLMethods() {
        // Test foreground HSL
        let text = "Hello"
        
        // Pure red
        let redText = text.hsl(0, 100, 50, to: .bit24)
        XCTAssertTrue(redText.contains("\u{001B}[38;2;255;0;0m"))
        
        // Pure green
        let greenText = text.hsl(120, 100, 50, to: .bit24)
        XCTAssertTrue(greenText.contains("\u{001B}[38;2;0;255;0m"))
        
        // Gray
        let grayText = text.hsl(0, 0, 50, to: .bit24)
        XCTAssertTrue(grayText.contains("\u{001B}[38;2;128;128;128m"))
        
        // Test with HSL tuple
        let hslColor: HSL = (hue: 240, saturation: 100, lightness: 50)
        let blueText = text.hsl(hslColor, to: .bit24)
        XCTAssertTrue(blueText.contains("\u{001B}[38;2;0;0;255m"))
    }
    
    func testStringOnHSLMethods() {
        // Test background HSL
        let text = "Hello"
        
        // Pure red background
        let redBgText = text.onHsl(0, 100, 50, to: .bit24)
        XCTAssertTrue(redBgText.contains("\u{001B}[48;2;255;0;0m"))
        
        // Pure green background
        let greenBgText = text.onHsl(120, 100, 50, to: .bit24)
        XCTAssertTrue(greenBgText.contains("\u{001B}[48;2;0;255;0m"))
        
        // Gray background
        let grayBgText = text.onHsl(0, 0, 50, to: .bit24)
        XCTAssertTrue(grayBgText.contains("\u{001B}[48;2;128;128;128m"))
        
        // Test with HSL tuple
        let hslColor: HSL = (hue: 240, saturation: 100, lightness: 50)
        let blueBgText = text.onHsl(hslColor, to: .bit24)
        XCTAssertTrue(blueBgText.contains("\u{001B}[48;2;0;0;255m"))
    }
    
    func testHSL8BitApproximation() {
        // Test that 8-bit approximation works
        let text = "Hello"
        
        // This should use ColorApproximation to convert to 8-bit
        let redText = text.hsl(0, 100, 50) // default is .bit8Approximated
        // Should contain an 8-bit color code, not 24-bit
        XCTAssertFalse(redText.contains("38;2;"))
        XCTAssertTrue(redText.contains("\u{001B}["))
        
        let bgText = text.onHsl(120, 100, 50)
        XCTAssertFalse(bgText.contains("48;2;"))
        XCTAssertTrue(bgText.contains("\u{001B}["))
    }
    
    func testHSLChaining() {
        // Test that HSL methods can be chained with other methods
        let text = "Hello"
        
        let styledText = text.hsl(180, 100, 50).bold.underline
        // Should contain escape sequences for color, bold, and underline
        XCTAssertTrue(styledText.contains("\u{001B}["))
        XCTAssertTrue(styledText.contains("1;")) // bold
        XCTAssertTrue(styledText.contains("4m")) // underline
        
        let complexText = text.hsl(60, 100, 50).onHsl(300, 100, 50, to: .bit24).italic
        // Should contain escape sequences for foreground, background, and italic
        XCTAssertTrue(complexText.contains("\u{001B}["))
        XCTAssertTrue(complexText.contains("3m")) // italic
        XCTAssertTrue(complexText.contains("48;2;")) // 24-bit background color
    }
    
    func testHSLWithDisabledRainbow() {
        Rainbow.enabled = false
        
        let text = "Hello"
        let result = text.hsl(0, 100, 50)
        XCTAssertEqual(result, text)
        
        let bgResult = text.onHsl(120, 100, 50)
        XCTAssertEqual(bgResult, text)
        
        Rainbow.enabled = true
    }
    
    func testHSLEdgeCases() {
        // Test various edge cases
        let text = "Test"
        
        // Hue at boundaries
        let hue360 = text.hsl(360, 100, 50, to: .bit24)
        let hue0 = text.hsl(0, 100, 50, to: .bit24)
        XCTAssertEqual(hue360, hue0) // 360 degrees should equal 0 degrees
        
        // Low saturation, high lightness (pastel colors)
        let pastel = text.hsl(180, 25, 80, to: .bit24)
        XCTAssertTrue(pastel.contains("\u{001B}[38;2;"))
        
        // High saturation, low lightness (dark colors)
        let dark = text.hsl(60, 100, 20, to: .bit24)
        XCTAssertTrue(dark.contains("\u{001B}[38;2;"))
    }
}
