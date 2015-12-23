//
//  ModesExtractor.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/23.
//  Copyright © 2015年 OneV's Den. All rights reserved.
//

protocol ModesExtractor {
    typealias ResultType
    func extractModeCodes(string: String) -> (codes: [ResultType], text: String)
}

struct ConsoleModesExtractor: ModesExtractor {
    typealias ResultType = UInt8
    func extractModeCodes(string: String) -> (codes: [UInt8], text: String) {
        let token = ControlCode.CSI
        var index = string.startIndex.advancedBy(token.characters.count)
        var codesString = ""
        while string.characters[index] != "m" {
            codesString.append(string.characters[index])
            index = index.successor()
        }
        
        let codes = codesString.characters.split(";").flatMap { UInt8(String($0)) }
        
        let startIndex = index.successor()
        let endIndex = string.endIndex.advancedBy(-"\(token)0m".characters.count)
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
            index = index.advancedBy(token.characters.count)
            
            while string.characters[index] != ";" {
                codesString.append(string.characters[index])
                index = index.successor()
            }
            
            codes.append(codesString)
            index = index.successor()
            outer = String(string.characters[index])
        }
        
        let startIndex = index
        let endIndex = string.endIndex.advancedBy(-"\(token);".characters.count)
        let text = String(string.characters[startIndex ..< endIndex])
        
        return (codes, text)
    }
}