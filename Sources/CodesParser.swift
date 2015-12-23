//
//  CodesParser.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/23.
//  Copyright © 2015年 OneV's Den. All rights reserved.
//

protocol CodesParser {
    typealias SourceType
    func parseModeCodes(codes: [SourceType]) ->
        (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?)
}

struct ConsoleCodesParser: CodesParser {
    typealias SourceType = UInt8
    func parseModeCodes(codes: [UInt8]) -> (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?) {
        var color: Color? = nil
        var backgroundColor: BackgroundColor? = nil
        var styles: [Style]? = nil
        
        for code in codes {
            if let c = Color(rawValue: code) {
                color = c
            } else if let bg = BackgroundColor(rawValue: code) {
                backgroundColor = bg
            } else if let style = Style(rawValue: code) {
                if styles == nil {
                    styles = []
                }
                styles!.append(style)
            }
        }
        
        return (color, backgroundColor, styles)
    }
}

struct XcodeColorsCodesParser: CodesParser {
    typealias SourceType = String
    func parseModeCodes(codes: [String]) -> (color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?) {
        var color: Color? = nil
        var backgroundColor: BackgroundColor? = nil
        
        for code in codes {
            if let c = Color(xcodeColorsDescription: code) {
                color = c
            } else if let bg = BackgroundColor(xcodeColorsDescription: code) {
                backgroundColor = bg
            }
        }
        
        return (color, backgroundColor, nil)
    }
}