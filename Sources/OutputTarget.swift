//
//  OutputTarget.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/23.
//  Copyright © 2015年 OneV's Den. All rights reserved.
//

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

private func getEnvValue(key: String) -> String? {
    let value = getenv(key)
    return value != nil ? String.fromCString(value) : nil
}

public enum OutputTarget {
    case Unknown
    case Console
    case XcodeColors
    
    static var currentOutputTarget: OutputTarget = {
        // Check if Xcode Colors is installed and enabled.
        let xcodeColorsEnabled = (getEnvValue("XcodeColors") == "YES")
        if xcodeColorsEnabled {
            return .XcodeColors
        }
        
        // Check if we are in any term env and the output is a tty.
        let termType = getEnvValue("TERM")
        if let t = termType where t.lowercaseString != "dumb" && isatty(fileno(stdout)) != 0 {
            return .Console
        }
        
        return .Unknown
    }()
}
