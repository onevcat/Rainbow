//
//  StringGenerator.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/23.
//  Copyright © 2015年 OneV's Den. All rights reserved.
//

protocol StringGenerator {
    func generateStringColor(color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String) -> String
}

struct ConsoleStringGenerator: StringGenerator {
    func generateStringColor(color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String) -> String {
        var codes: [UInt8] = []
        if let color = color {
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
            return "\(ControlCode.CSI)\(codes.map{String($0)}.joinWithSeparator(";"))m\(text)\(ControlCode.CSI)0m"
        }
    }
}

struct XcodeColorsStringGenerator: StringGenerator {
    func generateStringColor(color: Color?, backgroundColor: BackgroundColor?, styles: [Style]?, text: String) -> String {
        let hasAttributes = color != nil || backgroundColor != nil
        if hasAttributes {
            var result = ""
            if let color = color where color != .Default {
                result += "\(ControlCode.CSI)\(color.xcodeColorsDescription);"
            }
            
            if let backgroundColor = backgroundColor where backgroundColor != .Default {
                result += "\(ControlCode.CSI)\(backgroundColor.xcodeColorsDescription);"
            }
            
            result += text
            result += "\(ControlCode.CSI);"
            
            return result
        } else {
            return text
        }
    }
}