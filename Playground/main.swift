import Rainbow
import Foundation

// MARK: - Helper

extension String {
    static func * (left: String, right: Int) -> String {
        String(repeating: left, count: right)
    }
}

func section(_ title: String) {
    print()
    print(("=" * 60).cyan)
    print(title.bold.cyan)
    print(("=" * 60).cyan)
    print()
}

func subsection(_ title: String) {
    print(title.bold.underline)
}

// MARK: - Header

print()
print(("=" * 60).lightCyan)
print("Rainbow Demo".bold.lightCyan + " - Terminal Color Library for Swift".lightCyan)
print(("=" * 60).lightCyan)

// MARK: - Basic Foreground Colors

section("Basic Foreground Colors")

subsection("Standard Colors:")
print("  Black:   " + "Sample Text".black + "  (may not visible on dark bg)")
print("  Red:     " + "Sample Text".red)
print("  Green:   " + "Sample Text".green)
print("  Yellow:  " + "Sample Text".yellow)
print("  Blue:    " + "Sample Text".blue)
print("  Magenta: " + "Sample Text".magenta)
print("  Cyan:    " + "Sample Text".cyan)
print("  White:   " + "Sample Text".white)
print()

subsection("Light/Bright Colors:")
print("  Light Black:   " + "Sample Text".lightBlack + "  (dark grey)")
print("  Light Red:     " + "Sample Text".lightRed)
print("  Light Green:   " + "Sample Text".lightGreen)
print("  Light Yellow:  " + "Sample Text".lightYellow)
print("  Light Blue:    " + "Sample Text".lightBlue)
print("  Light Magenta: " + "Sample Text".lightMagenta)
print("  Light Cyan:    " + "Sample Text".lightCyan)
print("  Light White:   " + "Sample Text".lightWhite + "  (light grey)")

// MARK: - Background Colors

section("Background Colors")

subsection("Standard Backgrounds:")
print("  " + "  Red Background    ".onRed)
print("  " + "  Green Background  ".onGreen)
print("  " + "  Yellow Background ".black.onYellow)
print("  " + "  Blue Background   ".onBlue)
print("  " + "  Magenta Background".onMagenta)
print("  " + "  Cyan Background   ".black.onCyan)
print("  " + "  White Background  ".black.onWhite)
print()

subsection("Light Backgrounds:")
print("  " + "  Light Red Background    ".black.onLightRed)
print("  " + "  Light Green Background  ".black.onLightGreen)
print("  " + "  Light Yellow Background ".black.onLightYellow)
print("  " + "  Light Blue Background   ".black.onLightBlue)

// MARK: - Text Styles

section("Text Styles")

print("  Bold:          " + "Bold Text".bold)
print("  Dim:           " + "Dim Text".dim)
print("  Italic:        " + "Italic Text".italic)
print("  Underline:     " + "Underlined Text".underline)
print("  Blink:         " + "Blinking Text".blink + "  (terminal dependent)")
print("  Swap:          " + "Swapped Colors".swap)
print("  Strikethrough: " + "Strikethrough Text".strikethrough)

// MARK: - Chaining Colors and Styles

section("Chaining Colors and Styles")

print("  " + "Red + Bold".red.bold)
print("  " + "Green + Italic".green.italic)
print("  " + "Blue + Underline".blue.underline)
print("  " + "Yellow + Bold + Underline".yellow.bold.underline)
print("  " + "Magenta + Bold + Italic".magenta.bold.italic)
print("  " + "Cyan on Blue + Bold".cyan.onBlue.bold)
print("  " + "White on Red + Bold + Underline".white.onRed.bold.underline)
print("  " + "Red + Strikethrough + Dim".red.strikethrough.dim)

// MARK: - 8-bit Colors (256 color palette)

section("8-bit Colors (256 Color Palette)")

subsection("Standard Colors (0-15):")
for i: UInt8 in stride(from: 0, through: 15, by: 1) {
    let label = String(format: "%3d", i)
    print("  \(label): " + "███".bit8(i), terminator: "")
    if (i + 1) % 8 == 0 { print() }
}
print()

subsection("Color Cube Sample (216 colors: 16-231):")
let colorIndices: [UInt8] = [
    16, 22, 28, 34, 40, 46,
    52, 58, 64, 70, 76, 82,
    88, 94, 100, 106, 112, 118,
    124, 130, 136, 142, 148, 154,
    160, 166, 172, 178, 184, 190,
    196, 202, 208, 214, 220, 226
]
for (index, i) in colorIndices.enumerated() {
    let label = String(format: "%3d", i)
    print("  \(label): " + "██".bit8(i), terminator: "")
    if (index + 1) % 6 == 0 { print() }
}
print()

subsection("Grayscale (232-255):")
for i: UInt8 in stride(from: 232, through: 255, by: 1) {
    print("  " + "██".bit8(i), terminator: "")
    if (i - 232 + 1) % 12 == 0 { print() }
}

// MARK: - 24-bit True Colors

section("24-bit True Colors (RGB)")

subsection("Direct RGB Values:")
print("  RGB(255, 0, 0):    " + "Sample Text".bit24(255, 0, 0))
print("  RGB(0, 255, 0):    " + "Sample Text".bit24(0, 255, 0))
print("  RGB(0, 0, 255):    " + "Sample Text".bit24(0, 0, 255))
print("  RGB(255, 165, 0):  " + "Sample Text".bit24(255, 165, 0) + "  (Orange)")
print("  RGB(128, 0, 128):  " + "Sample Text".bit24(128, 0, 128) + "  (Purple)")
print()

subsection("Background RGB:")
print("  " + "  RGB Background (255, 200, 100)  ".black.onBit24(255, 200, 100))
print("  " + "  RGB Background (100, 200, 255)  ".black.onBit24(100, 200, 255))

// MARK: - Hex Colors

section("Hex Colors")

subsection("Foreground (8-bit approximated):")
print("  #FF6B6B (Soft Red):     " + "Sample Text".hex("#FF6B6B"))
print("  #4ECDC4 (Turquoise):    " + "Sample Text".hex("#4ECDC4"))
print("  #45B7D1 (Sky Blue):     " + "Sample Text".hex("#45B7D1"))
print("  #FFA07A (Light Salmon): " + "Sample Text".hex("#FFA07A"))
print("  #98D8C8 (Mint):         " + "Sample Text".hex("#98D8C8"))
print()

subsection("Foreground (24-bit true color):")
print("  #FF6B6B: " + "Sample Text".hex("#FF6B6B", to: .bit24))
print("  #4ECDC4: " + "Sample Text".hex("#4ECDC4", to: .bit24))
print("  #45B7D1: " + "Sample Text".hex("#45B7D1", to: .bit24))
print()

subsection("Hex as Integer:")
print("  0xFF6B6B: " + "Sample Text".hex(0xFF6B6B))
print("  0x00FF00: " + "Sample Text".hex(0x00FF00))
print("  0x0080FF: " + "Sample Text".hex(0x0080FF))
print()

subsection("Background Hex Colors:")
print("  " + "  #FF6B6B Background  ".black.onHex("#FF6B6B"))
print("  " + "  #4ECDC4 Background  ".black.onHex("#4ECDC4"))
print("  " + "  #45B7D1 Background  ".black.onHex("#45B7D1"))

// MARK: - HSL Colors

section("HSL Colors (Hue, Saturation, Lightness)")

subsection("HSL Examples:")
print("  HSL(0, 100, 50):   " + "Red".hsl(0, 100, 50) + "       (Pure Red)")
print("  HSL(120, 100, 50): " + "Green".hsl(120, 100, 50) + "     (Pure Green)")
print("  HSL(240, 100, 50): " + "Blue".hsl(240, 100, 50) + "      (Pure Blue)")
print("  HSL(60, 100, 50):  " + "Yellow".hsl(60, 100, 50) + "    (Pure Yellow)")
print("  HSL(300, 100, 50): " + "Magenta".hsl(300, 100, 50) + "   (Pure Magenta)")
print()

subsection("HSL with 24-bit output:")
print("  HSL(180, 50, 60): " + "Teal".hsl(180, 50, 60, to: .bit24))
print("  HSL(270, 60, 70): " + "Lavender".hsl(270, 60, 70, to: .bit24))
print()

subsection("HSL Background:")
print("  " + "  HSL(45, 100, 70) Background  ".black.onHsl(45, 100, 70))

// MARK: - Builder Pattern

section("Builder Pattern (Performance Optimized)")

let builder1 = "Styled with Builder".styled
    .red
    .bold
    .underline
    .build()
print("  " + builder1)

let builder2 = "Complex Styling".styled
    .lightGreen
    .onBlue
    .bold
    .italic
    .build()
print("  " + builder2)

let builder3 = "Multiple Styles".styled
    .yellow
    .onMagenta
    .bold
    .underline
    .blink
    .build()
print("  " + builder3)

let builder4 = "Hex via Builder".styled
    .hex("#E91E63")
    .bold
    .build()
print("  " + builder4)

// MARK: - Batch Application API

section("Batch Application API")

let warning = "Warning".applyingAll(
    color: .named(.red),
    backgroundColor: .named(.yellow),
    styles: [.bold, .underline]
)
print("  " + warning)

let success = "Success".applyingAll(
    color: .named(.green),
    styles: [.bold]
)
print("  " + success)

let info = "Info".applyingAll(
    color: .named(.blue),
    styles: [.italic]
)
print("  " + info)

let custom8bit = "Custom 8-bit".applyingAll(
    color: .bit8(208),
    backgroundColor: .bit8(17),
    styles: [.bold]
)
print("  " + custom8bit)

// MARK: - Direct Code Application

section("Direct Code Application")

let output = "The quick brown fox jumps over the lazy dog"
    .applyingCodes(Color.red, BackgroundColor.yellow, Style.bold)
print("  " + output)

// MARK: - Rainbow.Entry API

section("Rainbow.Entry API (Low-level)")

let entry = Rainbow.Entry(
    segments: [
        .init(text: "Hello ", color: .named(.magenta)),
        .init(text: "Rainbow", color: .bit8(214), backgroundColor: .named(.lightBlue), styles: [.underline]),
        .init(text: ". "),
        .init(text: "Nice to ", color: .bit8(31), styles: [.blink]),
        .init(text: "see you!", color: .bit8(39), styles: [.italic])
    ]
)
print("  " + Rainbow.generateString(for: entry))

// MARK: - Nested Styling

section("Nested Styling (String Interpolation)")

let nested1 = "This has \("colored".green) words in it".underline
print("  " + nested1)

let nested2 = "Mix \("red".red), \("green".green), and \("blue".blue) together".bold
print("  " + nested2)

let nested3 = "Outer style".yellow.bold + " + " + "Inner style".cyan.italic
print("  " + nested3)

// MARK: - Clear/Remove Styles

section("Clear/Remove Styles")

let styled = "Styled Text".red.bold.underline
print("  Original:         " + styled)
print("  clearColor:       " + styled.clearColor)
print("  clearStyles:      " + styled.clearStyles)
print("  .raw:             " + styled.raw)

// MARK: - Practical Examples

section("Practical Examples")

print()
subsection("Log Levels:")
print("  " + "[ERROR]".red.bold + "   Something went wrong!")
print("  " + "[WARN]".yellow.bold + "    This is a warning")
print("  " + "[INFO]".blue + "    Informational message")
print("  " + "[DEBUG]".lightBlack + "   Debug information")
print("  " + "[SUCCESS]".green.bold + " Operation completed")
print()

subsection("Progress Bar:")
let completed = 75
let bar = String(repeating: "█", count: completed / 2)
let remaining = String(repeating: "░", count: (100 - completed) / 2)
print("  " + bar.green + remaining.lightBlack + " \(completed)%")
print()

subsection("Status Messages:")
print("  " + "✓".green.bold + " File saved successfully")
print("  " + "✗".red.bold + " Failed to connect to server")
print("  " + "⚠".yellow.bold + " Disk space running low")
print("  " + "ℹ".blue.bold + " Update available")
print()

subsection("Code Syntax Highlighting:")
print("  " + "func".magenta.bold + " " + "greet".blue + "(" + "name".cyan + ": " + "String".green + ") {")
print("      " + "print".magenta + "(" + "\"Hello, \\(name)!\"".red + ")")
print("  }")
print()

subsection("Strikethrough for Completed Tasks:")
let todoList = """
  TODO List:
    ✓ \("Setup project".strikethrough.dim)
    ✓ \("Write tests".strikethrough.dim)
    - \("Implement feature".yellow)
    - Code review
"""
print(todoList)
print()

subsection("Deprecation Notice:")
print("  Error: \("Deprecated method".red.strikethrough) - use new API instead")
print("  \("Old price: $99.99".strikethrough) \("New price: $79.99".green.bold)")

// MARK: - Chinese Poetry Examples

section("Chinese Poetry Examples")

print("  接天莲叶\("无穷碧".green)，映日荷花\("别样红".red)")
print("  \("两只黄鹂".yellow)鸣翠柳，一行白鹭\("上青天".lightBlue)。".lightGreen.underline)
print()
print("  停车坐爱\("枫林晚".bit8(31))，\("霜叶".bit8(160))红于\("二月花".bit8(198))。")
print("  \("一道残阳".bit8(202))铺水中，\("半江瑟瑟".bit8(30).onBit8(226))半江红。")
print()
print("  黑云压城\("城欲摧".hex("#666"))，甲光向日\("金鳞开".hex("000000").onHex("#E6B422"))。")
print("  日出江花\("红胜火".hex(0xd11a2d))，春来江水\("绿如蓝".hex(0x10aec2))")
print()
print("  疏影横斜\("水清浅".bit24(36, 116, 181))，暗香浮动\("月黄昏".bit24(254, 215, 26))")
print("  \("春色满园".hex("#ea517f", to: .bit24))关不住，\("一枝红杏".hex("#f43e06", to: .bit24))出墙来。")
print()
print("  \("天街".hsl(0, 0, 70))小雨润如酥，\("草色".hsl(120, 20, 80))遥看近却无")
print("  \("最是".hsl(90, 60, 70))一年春好处，绝胜\("烟柳".hsl(120, 30, 75))满皇都")

// MARK: - Configuration Demo

section("Configuration")

print("  Colors are currently: " + (Rainbow.enabled ? "ENABLED".green.bold : "DISABLED".red.bold))
print("  Output target: " + "\(Rainbow.outputTarget)".cyan)
print()

print("  Disabling colors...")
Rainbow.enabled = false
print("  " + "This text should be plain".red.bold)
print()

print("  Re-enabling colors...")
Rainbow.enabled = true
print("  " + "This text should be colored again!".green.bold)

// MARK: - Footer

print()
print(("=" * 60).lightCyan)
print("Demo Complete!".bold.lightCyan)
print(("=" * 60).lightCyan)
print()
