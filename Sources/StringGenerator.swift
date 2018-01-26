//
//  StringGenerator.swift
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

protocol StringGenerator {
    func generate(withStringColor stringColor: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String) -> String
}

struct ConsoleStringGenerator: StringGenerator {
    func generate(withStringColor stringColor: Color? = nil, backgroundColor: BackgroundColor? = nil, styles: [Style]? = nil, text: String) -> String {
        var codes: [UInt8] = []
        if let color = stringColor {
            codes.append(color.value)
        }
        if let backgroundColor = backgroundColor {
            codes.append(backgroundColor.value)
        }
        if let styles = styles {
            codes += styles.map{$0.value}
        }
        
        if codes.isEmpty {
            return text
        } else {
            return "\(ControlCode.CSI)\(codes.map{String($0)}.joined(separator: ";"))m\(text)\(ControlCode.CSI)0m"
        }
    }
}

struct XcodeColorsStringGenerator: StringGenerator {
    func generate(withStringColor stringColor: Color? = nil, backgroundColor: BackgroundColor? = nil, styles: [Style]? = nil, text: String) -> String {
        
        var result = ""
        var added = false
        
        if let color = stringColor, color != .default {
            result += "\(ControlCode.CSI)\(color.xcodeColorsDescription);"
            added = true
        }
        
        if let backgroundColor = backgroundColor, backgroundColor != .default {
            result += "\(ControlCode.CSI)\(backgroundColor.xcodeColorsDescription);"
            added = true
        }
        
        result += text
        
        if added {
            result += "\(ControlCode.CSI);"
        }

        return result
    }
}
