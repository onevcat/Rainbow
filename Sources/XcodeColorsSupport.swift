//
//  XcodeColorsSupport.swift
//  Rainbow
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

protocol XcodeColorsConvertible {
    var xcodeColorsDescription: String { get }
    init?(xcodeColorsDescription string: String)
}

// MARK: - XcodeColorsConvertible
// Supports XcodeColors format of mode string.
extension Color: XcodeColorsConvertible {
    var xcodeColorsDescription: String {
        switch self {
        case .black: return "fg0,0,0"
        case .red: return "fg255,0,0"
        case .green: return "fg0,204,0"
        case .yellow: return "fg255,255,0"
        case .blue: return "fg0,0,255"
        case .magenta: return "fg255,0,255"
        case .cyan: return "fg0,255,255"
        case .white: return "fg204,204,204"
        case .default: return ""
        case .lightBlack: return "fg128,128,128"
        case .lightRed: return "fg255,102,102"
        case .lightGreen: return "fg102,255,102"
        case .lightYellow: return "fg255,255,102"
        case .lightBlue: return "fg102,102,255"
        case .lightMagenta: return "fg255,102,255"
        case .lightCyan: return "fg102,255,255"
        case .lightWhite: return "fg255,255,255"
        }
    }
    
    init?(xcodeColorsDescription string: String) {
        switch string {
        case Color.black.xcodeColorsDescription: self = .black
        case Color.red.xcodeColorsDescription: self = .red
        case Color.green.xcodeColorsDescription: self = .green
        case Color.yellow.xcodeColorsDescription: self = .yellow
        case Color.blue.xcodeColorsDescription: self = .blue
        case Color.magenta.xcodeColorsDescription: self = .magenta
        case Color.cyan.xcodeColorsDescription: self = .cyan
        case Color.white.xcodeColorsDescription: self = .white
        case Color.lightBlack.xcodeColorsDescription: self = .lightBlack
        case Color.lightRed.xcodeColorsDescription: self = .lightRed
        case Color.lightGreen.xcodeColorsDescription: self = .lightGreen
        case Color.lightYellow.xcodeColorsDescription: self = .lightYellow
        case Color.lightBlue.xcodeColorsDescription: self = .lightBlue
        case Color.lightMagenta.xcodeColorsDescription: self = .lightMagenta
        case Color.lightCyan.xcodeColorsDescription: self = .lightCyan
        case Color.lightWhite.xcodeColorsDescription: self = .lightWhite
        default: return nil
        }
    }
}

extension BackgroundColor: XcodeColorsConvertible {
    var xcodeColorsDescription: String {
        switch self {
        case .black: return "bg0,0,0"
        case .red: return "bg255,0,0"
        case .green: return "bg0,204,0"
        case .yellow: return "bg255,255,0"
        case .blue: return "bg0,0,255"
        case .magenta: return "bg255,0,255"
        case .cyan: return "bg0,255,255"
        case .white: return "bg204,204,204"
        case .default: return ""
        }
    }
    
    init?(xcodeColorsDescription string: String) {
        switch string {
        case BackgroundColor.black.xcodeColorsDescription: self = .black
        case BackgroundColor.red.xcodeColorsDescription: self = .red
        case BackgroundColor.green.xcodeColorsDescription: self = .green
        case BackgroundColor.yellow.xcodeColorsDescription: self = .yellow
        case BackgroundColor.blue.xcodeColorsDescription: self = .blue
        case BackgroundColor.magenta.xcodeColorsDescription: self = .magenta
        case BackgroundColor.cyan.xcodeColorsDescription: self = .cyan
        case BackgroundColor.white.xcodeColorsDescription: self = .white
        default: return nil
        }
    }
}
