//
//  ColorApproximatedTests.swift
//  RainbowTests
//
//  Created by 王 巍 on 2021/03/05.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import XCTest
@testable import Rainbow

class ColorApproximatedTests: XCTestCase {

    func testHex3ColorApproximation() {
        let c1 = ColorApproximation(color: "F00") // #FF0000
        XCTAssertNotNil(c1)
        XCTAssertEqual(c1!.rgb.0, 255)
        XCTAssertEqual(c1!.rgb.1, 0)
        XCTAssertEqual(c1!.rgb.2, 0)

        let c2 = ColorApproximation(color: "#0F0") // #00FF00
        XCTAssertNotNil(c2)
        XCTAssertEqual(c2!.rgb.0, 0)
        XCTAssertEqual(c2!.rgb.1, 255)
        XCTAssertEqual(c2!.rgb.2, 0)

        let c3 = ColorApproximation(color: "#00A") // #0000AA
        XCTAssertNotNil(c3)
        XCTAssertEqual(c3!.rgb.0, 0)
        XCTAssertEqual(c3!.rgb.1, 0)
        XCTAssertEqual(c3!.rgb.2, 170)

        let c4 = ColorApproximation(color: "CCC") // #CCCCCC
        XCTAssertNotNil(c4)
        XCTAssertEqual(c4!.rgb.0, 204)
        XCTAssertEqual(c4!.rgb.1, 204)
        XCTAssertEqual(c4!.rgb.2, 204)

        let c5 = ColorApproximation(color: "0xCCC")
        XCTAssertNil(c5)
    }

    func testHex6ColorApproximation() {
        let c1 = ColorApproximation(color: "FF00A0") // #FF00A0
        XCTAssertNotNil(c1)
        XCTAssertEqual(c1!.rgb.0, 255)
        XCTAssertEqual(c1!.rgb.1, 0)
        XCTAssertEqual(c1!.rgb.2, 160)

        let c2 = ColorApproximation(color: "#000000") // #000000
        XCTAssertNotNil(c2)
        XCTAssertEqual(c2!.rgb.0, 0)
        XCTAssertEqual(c2!.rgb.1, 0)
        XCTAssertEqual(c2!.rgb.2, 0)

        let c3 = ColorApproximation(color: "FFFFFF") // #FFFFFF
        XCTAssertNotNil(c3)
        XCTAssertEqual(c3!.rgb.0, 255)
        XCTAssertEqual(c3!.rgb.1, 255)
        XCTAssertEqual(c3!.rgb.2, 255)

        let c4 = ColorApproximation(color: "CCCC")
        XCTAssertNil(c4)

        let c5 = ColorApproximation(color: "0xCCCCCC")
        XCTAssertNil(c5)
    }

    func testHexUIntColorApproximation() {
        let c1 = ColorApproximation(color: 0xFF00A0)
        XCTAssertNotNil(c1)
        XCTAssertEqual(c1!.rgb.0, 255)
        XCTAssertEqual(c1!.rgb.1, 0)
        XCTAssertEqual(c1!.rgb.2, 160)

        let c2 = ColorApproximation(color: 0)
        XCTAssertNotNil(c2)
        XCTAssertEqual(c2!.rgb.0, 0)
        XCTAssertEqual(c2!.rgb.1, 0)
        XCTAssertEqual(c2!.rgb.2, 0)

        let c3 = ColorApproximation(color: 255)
        XCTAssertNotNil(c3)
        XCTAssertEqual(c3!.rgb.0, 0)
        XCTAssertEqual(c3!.rgb.1, 0)
        XCTAssertEqual(c3!.rgb.2, 255)

        let c4 = ColorApproximation(color: 0x0FFFAA)
        XCTAssertNotNil(c4)
        XCTAssertEqual(c4!.rgb.0, 15)
        XCTAssertEqual(c4!.rgb.1, 255)
        XCTAssertEqual(c4!.rgb.2, 170)

        let c5 = ColorApproximation(color: 0xCCCC) // #00CCCC
        XCTAssertNotNil(c5)
        XCTAssertEqual(c5!.rgb.0, 0)
        XCTAssertEqual(c5!.rgb.1, 204)
        XCTAssertEqual(c5!.rgb.2, 204)

        let c6 = ColorApproximation(color: 0xFFFFFFFF) // with alpha
        XCTAssertNil(c6)
    }

    // Some random ANSI256 color pairs
    let pairs: [(UInt32, UInt8)] = [
        (0xff0000, 196),
        (0xafafd7, 189),
        (0x000000, 16),
        (0xffffff, 231),
        (0xaf00ff, 165),
        (0x00ffd7, 51),
        (0xff87ff, 219)
    ]

    func testColorConversion() {
        pairs.forEach {
            XCTAssertEqual(ColorApproximation(color: $0.0)?.convert(to: .bit8Approximated), ColorType.bit8($0.1))
            XCTAssertEqual(ColorApproximation(color: $0.0)?.convert(to: .bit8Approximated), BackgroundColorType.bit8($0.1))
        }
    }
}
