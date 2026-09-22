import XCTest
@testable import Rainbow

final class CompoundResetTests: XCTestCase {
    private func withConsoleOutput(_ body: () -> Void) {
        let enabled = Rainbow.enabled
        let target = Rainbow.outputTarget
        defer {
            Rainbow.enabled = enabled
            Rainbow.outputTarget = target
        }
        Rainbow.enabled = true
        Rainbow.outputTarget = .console
        body()
    }

    func testApplyingCodesResetsExistingAttributes() {
        withConsoleOutput {
            let text = "\u{001B}[31;44;1mtext\u{001B}[0m"
            XCTAssertEqual(text.applyingCodes(Style.default, Style.italic),
                           "\u{001B}[3mtext\u{001B}[0m")
        }
    }

    func testApplyingStylesResetsExistingAttributes() {
        withConsoleOutput {
            let text = "\u{001B}[31;44;1mtext\u{001B}[0m"
            XCTAssertEqual(text.applyingStyles([.default, .italic]),
                           "\u{001B}[3mtext\u{001B}[0m")
        }
    }

    func testApplyingAllResetsExistingAttributes() {
        withConsoleOutput {
            let text = "\u{001B}[31;44;1mtext\u{001B}[0m"
            XCTAssertEqual(text.applyingAll(styles: [.default, .italic]),
                           "\u{001B}[3mtext\u{001B}[0m")
        }
    }

    func testResetAppliesToEverySegment() {
        withConsoleOutput {
            let text = "\u{001B}[31;44;1mone\u{001B}[0m\u{001B}[32;4mtwo\u{001B}[0m"
            XCTAssertEqual(text.applyingStyles([.default, .italic]),
                           "\u{001B}[3mone\u{001B}[0m\u{001B}[3mtwo\u{001B}[0m")
        }
    }

    func testResetThenColorPreservesNewColor() {
        withConsoleOutput {
            let text = "\u{001B}[31;44;1mtext\u{001B}[0m"
            XCTAssertEqual(text.applyingCodes(Style.default, NamedColor.green, Style.italic),
                           "\u{001B}[32;3mtext\u{001B}[0m")
            XCTAssertEqual(text.applyingCodes(NamedColor.green, Style.default), "text")
        }
    }

    func testExtendedColorZeroComponentsDoNotClearExistingAttributes() {
        withConsoleOutput {
            let text = "\u{001B}[31;44;1mtext\u{001B}[0m"
            XCTAssertEqual(text.applyingCodes(ColorType.bit24((0, 128, 0))),
                           "\u{001B}[38;2;0;128;0;44;1mtext\u{001B}[0m")
            XCTAssertEqual(text.applyingStyles([.italic]),
                           "\u{001B}[31;44;1;3mtext\u{001B}[0m")
        }
    }

    func testResetClearsAllPreviousAttributes() {
        let entry = ConsoleEntryParser(text: "\u{001B}[31;44;1;4;0mtext").parse()
        XCTAssertEqual(entry.segments.count, 1)
        XCTAssertEqual(entry.segments[0].text, "text")
        XCTAssertTrue(entry.segments[0].isPlain)
    }

    func testAttributesAfterResetRemain() {
        let modes = ConsoleCodesParser().parse(modeCodes: [31, 44, 1, 0, 32, 3])
        XCTAssertEqual(modes.color, .named(.green))
        XCTAssertNil(modes.backgroundColor)
        XCTAssertEqual(modes.styles, [.italic])
    }

    func testRegenerationKeepsAttributesFollowingReset() {
        let entry = ConsoleEntryParser(text: "\u{001B}[31;0;32;3mtext").parse()
        XCTAssertEqual(ConsoleStringGenerator().generate(for: entry), "\u{001B}[32;3mtext\u{001B}[0m")
    }

    func testZeroColorComponentsAreNotResets() {
        let modes = ConsoleCodesParser().parse(modeCodes: [1, 38, 2, 0, 128, 0, 48, 5, 0])
        XCTAssertEqual(modes.color, .bit24((0, 128, 0)))
        XCTAssertEqual(modes.backgroundColor, .bit8(0))
        XCTAssertEqual(modes.styles, [.bold])
    }

    func testResetAfterExtendedColorClearsIt() {
        let modes = ConsoleCodesParser().parse(modeCodes: [38, 2, 0, 128, 0, 48, 5, 0, 0])
        XCTAssertNil(modes.color)
        XCTAssertNil(modes.backgroundColor)
        XCTAssertEqual(modes.styles, [.default])
    }
}
