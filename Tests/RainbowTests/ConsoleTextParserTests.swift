//
//  ConsoleTextParserTests.swift
//  RainbowTests
//
//  Created by 王 巍 on 2021/02/26.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import XCTest
@testable import Rainbow

class ConsoleTextParserTests: XCTestCase {

    func testParsePlainString() throws {
        let t = "Hello Rainbow"
        let entry = ConsoleEntryParser(text: t).parse()
        XCTAssertEqual(entry.segments.count, 1)
        XCTAssertEqual(entry.segments[0].text, "Hello Rainbow")
        XCTAssertTrue(entry.isPlain)
    }

    func testParseDefaultString() throws {
        let t = "\u{001B}[0mHello Rainbow\u{001B}[0m"
        let entry = ConsoleEntryParser(text: t).parse()
        XCTAssertEqual(entry.segments.count, 1)
        XCTAssertEqual(entry.segments[0].text, "Hello Rainbow")
        XCTAssertTrue(entry.isPlain)
    }

    func testParseSimpleConsoleString() throws {
        let t = "\u{001B}[31mHello Rainbow\u{001B}[0m"
        let entry = ConsoleEntryParser(text: t).parse()
        XCTAssertEqual(entry.segments.count, 1)
        XCTAssertEqual(entry.segments[0].text, "Hello Rainbow")
        XCTAssertEqual(entry.segments[0].color, .named(.red))
    }

    func testParseConsoleStringWithStyle() throws {
        let t = "\u{001B}[31;4;5mHello Rainbow\u{001B}[0m"
        let entry = ConsoleEntryParser(text: t).parse()
        XCTAssertEqual(entry.segments.count, 1)
        XCTAssertEqual(entry.segments[0].text, "Hello Rainbow")
        XCTAssertEqual(entry.segments[0].color, .named(.red))
        XCTAssertEqual(entry.segments[0].styles, [.underline, .blink])
    }

    func testParseMultipleConsoleString() throws {
        let t = "\u{001B}[31mHello \u{001B}[32mRainbow\u{001B}[0m"
        let entry = ConsoleEntryParser(text: t).parse()
        XCTAssertEqual(entry.segments.count, 2)
        XCTAssertEqual(entry.segments[0].text, "Hello ")
        XCTAssertEqual(entry.segments[0].color, .named(.red))
        XCTAssertEqual(entry.segments[1].text, "Rainbow")
        XCTAssertEqual(entry.segments[1].color, .named(.green))
    }

    func testParseMultipleConsoleStringWithUnformat() throws {
        let t = "Hi \u{001B}[31mHello \u{001B}[32mRainbow\u{001B}[0mend"
        let entry = ConsoleEntryParser(text: t).parse()
        XCTAssertEqual(entry.segments.count, 4)

        XCTAssertEqual(entry.segments[0].text, "Hi ")
        XCTAssertTrue(entry.segments[0].isPlain)

        XCTAssertEqual(entry.segments[1].text, "Hello ")
        XCTAssertEqual(entry.segments[1].color, .named(.red))

        XCTAssertEqual(entry.segments[2].text, "Rainbow")
        XCTAssertEqual(entry.segments[2].color, .named(.green))

        XCTAssertEqual(entry.segments[3].text, "end")
        XCTAssertTrue(entry.segments[3].isPlain)
    }
}
