import Rainbow

print("接天莲叶\("无穷碧".green)，映日荷花\("别样红".red)")
print("\("两只黄鹂".yellow)鸣翠柳，一行白鹭\("上青天".lightBlue)。".lightGreen.underline)

print("")

print("停车坐爱\("枫林晚".bit8(31))，\("霜叶".bit8(160))红于\("二月花".bit8(198))。")
print("\("一道残阳".bit8(202))铺水中，\("半江瑟瑟".bit8(30).onBit8(226))半江红。")

print("")

print("黑云压城\("城欲摧".hex("#666"))，甲光向日\("金鳞开".hex("000000").onHex("#E6B422"))。")
print("日出江花\("红胜火".hex(0xd11a2d))，春来江水\("绿如蓝".hex(0x10aec2))")

print("")

print("疏影横斜\("水清浅".bit24(36,116,181))，暗香浮动\("月黄昏".bit24(254,215,26))")
print("\("春色满园".hex("#ea517f", to: .bit24))关不住，\("一枝红杏".hex("#f43e06", to: .bit24))出墙来。")

print("")

print("\("天街".hsl(0, 0, 70))小雨润如酥，\("草色".hsl(120, 20, 80))遥看近却无")
print("\("最是".hsl(90, 60, 70))一年春好处，绝胜\("烟柳".hsl(120, 30, 75))满皇都")

print("")

let output = "The quick brown fox jumps over the lazy dog"
                .applyingCodes(Color.red, BackgroundColor.yellow, Style.bold)
print(output)

print("")

let entry = Rainbow.Entry(
    segments: [
        .init(text: "Hello ", color: .named(.magenta)),
        .init(text: "Rainbow.", color: .bit8(214), backgroundColor: .named(.lightBlue), styles: [.underline]),
        .init(text: " "),
        .init(text: "Nice to ", color: .bit8(31), styles: [.blink]),
        .init(text: "see you!", color: .bit8(39), styles: [.italic])
    ]
)
print(Rainbow.generateString(for: entry))

print("")

// Strikethrough examples
print("=== Strikethrough Style Examples ===".bold)
print("This is \("deleted text".strikethrough)")
print("Error: \("Deprecated method".red.strikethrough) - use new API instead")
print("\("Old price: $99.99".strikethrough) \("New price: $79.99".green.bold)")
print("")
print("Combining with other styles:")
print("  • \("Strikethrough + Bold".strikethrough.bold)")
print("  • \("Strikethrough + Italic".strikethrough.italic)")
print("  • \("Strikethrough + Underline".strikethrough.underline)")
print("  • \("Strikethrough + Red + Bold".red.strikethrough.bold)")
print("")
print("Complex example:")
let todoList = """
TODO List:
  ✓ \("Setup project".strikethrough.dim)
  ✓ \("Write tests".strikethrough.dim)
  - Implement feature
  - Code review
"""
print(todoList)