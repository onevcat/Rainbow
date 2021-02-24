//
//  Color.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/22.
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

public typealias RGB = (UInt8, UInt8, UInt8)

public enum ColorType: ModeCode {
    case named(Color)
    case bit8(UInt8)
    case bit24(RGB)

    @available(*, deprecated, message: "For backward compatibility.")
    var namedColor: Color? {
        switch self {
        case .named(let color): return color
        default: return nil
        }
    }

    public var value: [UInt8] {
        switch self {
        case .named(let color): return color.value
        case .bit8(let color): return [ControlCode.setColor, ControlCode.set8Bit, color]
        case .bit24(let rgb): return [ControlCode.setColor, ControlCode.set24Bit, rgb.0, rgb.1, rgb.2]
        }
    }
}

extension ColorType: Equatable {
    public static func == (lhs: ColorType, rhs: ColorType) -> Bool {
        switch (lhs, rhs) {
        case (.named(let color1), .named(let color2)): return color1 == color2
        case (.bit8(let color1), .bit8(let color2)): return color1 == color2
        case (.bit24(let color1), .bit24(let color2)): return color1 == color2
        default: return false
        }
    }
}

public typealias Color = NamedColor

/// Valid named text colors to use in `Rainbow`.
public enum NamedColor: UInt8, ModeCode {
    case black = 30
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    case `default` = 39
    case lightBlack = 90
    case lightRed
    case lightGreen
    case lightYellow
    case lightBlue
    case lightMagenta
    case lightCyan
    case lightWhite

    public var value: [UInt8] {
        return [rawValue]
    }
}
