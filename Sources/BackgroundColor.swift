//
//  BackgroundColor.swift
//  Rainbow
//
//  Created by WANG WEI on 2015/12/22.
//  Copyright © 2015年 OneV's Den. All rights reserved.
//

public enum BackgroundColor: UInt8, ModeCode {
    case Black = 40
    case Red
    case Green
    case Yellow
    case Blue
    case Magenta
    case Cyan
    case White
    case Default = 49
    
    public var value: UInt8 {
        return rawValue
    }
}
