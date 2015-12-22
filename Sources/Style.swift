//
//  Style.swift
//  Rainbow
//
//  Created by WANG WEI on 2015/12/22.
//  Copyright © 2015年 OneV's Den. All rights reserved.
//

public enum Style: UInt8, ModeCode {
    case Default = 0
    case Bold = 1
    case Dim = 2
    case Italic = 3
    case Underline = 4
    case Blink = 5
    case Swap = 7
    
    public var value: UInt8 {
        return rawValue
    }
}
