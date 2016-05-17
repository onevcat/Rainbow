//
//  ModesExtractor.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/23.
//
//  Copyright (c) 2015 Wei Wang <onevcat@gmail.com>
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

protocol ModesExtractor {
    associatedtype ResultType
    func extractModeCodes(string: String) -> (codes: [ResultType], text: String)
}

struct ConsoleModesExtractor: ModesExtractor {
    typealias ResultType = UInt8
    func extractModeCodes(string: String) -> (codes: [UInt8], text: String) {
        let token = ControlCode.CSI
        var index = string.index(string.startIndex, offsetBy: token.characters.count)
        var codesString = ""
        while string.characters[index] != "m" {
            codesString.append(string.characters[index])
            index = string.index(after: index)
        }
        
        let codes = codesString.characters.split(separator: ";", maxSplits: Int.max, omittingEmptySubsequences: false).flatMap { UInt8(String($0)) }
        let startIndex = index
        
        let endIndex = string.index(string.endIndex, offsetBy: -"\(token)0m".characters.count)
        let text = String(string.characters[startIndex ..< endIndex])
        
        return (codes, text)
    }
}

struct XcodeColorsModesExtractor: ModesExtractor {
    typealias ResultType = String
    func extractModeCodes(string: String) -> (codes: [String], text: String) {
        let token = ControlCode.CSI
        var index = string.startIndex
        
        var codes = [String]()
        
        var outer = String(string.characters[index]) //Start index should be the ESC control code
        while outer == ControlCode.ESC {
            var codesString = ""
            index = string.index(index, offsetBy: token.characters.count)
            
            while string.characters[index] != ";" {
                codesString.append(string.characters[index])
                index = string.index(after: index)
            }
            
            codes.append(codesString)
            index = string.index(after: index)
            outer = String(string.characters[index])
        }
        
        let startIndex = index
        
        let endIndex = string.index(string.endIndex, offsetBy: -"\(token);".characters.count)
        let text = String(string.characters[startIndex ..< endIndex])
        
        return (codes, text)
    }
}