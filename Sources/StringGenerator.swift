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
    func generate(for entry: Rainbow.Entry) -> String
}

struct ConsoleStringGenerator: StringGenerator {
    func generate(for entry: Rainbow.Entry) -> String {
        // Pre-calculate total capacity to minimize string reallocations
        let totalTextLength = entry.segments.reduce(0) { $0 + $1.text.count }
        let estimatedTotalLength = totalTextLength + (entry.segments.count * 20) // ANSI codes overhead
        
        var result = ""
        result.reserveCapacity(estimatedTotalLength)
        
        for segment in entry.segments {
            // Fast path for plain text segments
            if segment.isPlain {
                result.append(segment.text)
                continue
            }
            
            // Collect all codes
            var codes: [UInt8] = []
            if let color = segment.color {
                codes += color.value
            }
            if let backgroundColor = segment.backgroundColor {
                codes += backgroundColor.value
            }
            if let styles = segment.styles {
                codes += styles.flatMap{ $0.value }
            }
            
            if codes.isEmpty || segment.text.isEmpty {
                result.append(segment.text)
            } else {
                // Optimize ANSI sequence building
                result.append(ControlCode.CSI)
                
                // Build codes string more efficiently
                for (index, code) in codes.enumerated() {
                    if index > 0 {
                        result.append(";")
                    }
                    result.append(String(code))
                }
                
                result.append("m")
                result.append(segment.text)
                result.append(ControlCode.CSI)
                result.append("0m")
            }
        }
        
        return result
    }
}
