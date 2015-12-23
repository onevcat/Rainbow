//
//  Color.swift
//  Rainbow
//
//  Created by WANG WEI on 2015/12/22.
//  Copyright © 2015年 OneV's Den. All rights reserved.
//

public enum Color: UInt8, ModeCode {
    case Black = 30
    case Red
    case Green
    case Yellow
    case Blue
    case Magenta
    case Cyan
    case White
    case Default = 39
    case LightBlack = 90
    case LightRed
    case LightGreen
    case LightYellow
    case LightBlue
    case LightMagenta
    case LightCyan
    case LightWhite
    
    public var value: UInt8 {
        return rawValue
    }
}
