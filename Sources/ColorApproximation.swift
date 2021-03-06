//
//  ColorApproximation.swift
//  Rainbow
//
//  Created by 王 巍 on 2021/03/05.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

public enum HexColorTarget {
    case bit8Approximated
    case bit24
}

struct ColorApproximation {

    let rgb: RGB

    private init(hex3: UInt32) {
        rgb = (
            UInt8(((hex3 & 0xF00) >> 8).duplicate4bits()),
            UInt8(((hex3 & 0x0F0) >> 4).duplicate4bits()),
            UInt8(((hex3 & 0x00F) >> 0).duplicate4bits())
        )

    }

    private init(hex6: UInt32) {
        rgb = (
            UInt8((hex6 & 0xFF0000) >> 16),
            UInt8((hex6 & 0x00FF00) >> 8),
            UInt8((hex6 & 0x0000FF) >> 0)
        )
    }

    init?(color: String) {
        var hex = color
        if color.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }
        guard let hexNumber = UInt32(hex, radix: 16) else {
            return nil
        }
        switch hex.count {
        case 3:
            self.init(hex3: hexNumber)
        case 6:
            self.init(hex6: hexNumber)
        default:
            return nil
        }
    }

    init?(color: UInt32) {
        guard (0x000000 ... 0xFFFFFF) ~= color else {
            return nil
        }
        self.init(hex6: color)
    }

    func convert(to target: HexColorTarget) -> ColorType {
        switch target {
        case .bit8Approximated:
            return .bit8(convert8BitApproximation())
        case .bit24:
            return .bit24(rgb)
        }
    }

    func convert(to target: HexColorTarget) -> BackgroundColorType {
        switch target {
        case .bit8Approximated:
            return .bit8(convert8BitApproximation())
        case .bit24:
            return .bit24(rgb)
        }
    }

    private func convert8BitApproximation() -> UInt8 {
        let normalized = (
            6 * Int(rgb.0) / 256,
            6 * Int(rgb.1) / 256,
            6 * Int(rgb.2) / 256
        )
        return UInt8(16 + 36 * normalized.0 + 6 * normalized.1 + normalized.2)
    }
}

private extension UInt32 {
    func duplicate4bits() -> UInt32 {
        return (self << 4) + self
    }
}


