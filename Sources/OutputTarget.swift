//
//  OutputTarget.swift
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

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

private func getEnvValue(key: String) -> String? {
    guard let value = getenv(key) else {
        return nil
    }
    return String(cString: value)
}


///
/**
Output target of Rainbow.

- Unknown: Unknown target.
- Console: A valid console is detected connected.
- XcodeColors: Used in Xcode with XcodeColors enabled.
*/
public enum OutputTarget {
    case Unknown
    case Console
    case XcodeColors
    
    /// Detected output target by current envrionment.
    static var currentOutputTarget: OutputTarget = {
        // Check if Xcode Colors is installed and enabled.
        let xcodeColorsEnabled = (getEnvValue(key: "XcodeColors") == "YES")
        if xcodeColorsEnabled {
            return .XcodeColors
        }
        
        // Check if we are in any term env and the output is a tty.
        let termType = getEnvValue(key: "TERM")
        if let t = termType where t.lowercased() != "dumb" && isatty(fileno(stdout)) != 0 {
            return .Console
        }
        
        return .Unknown
    }()
}
