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