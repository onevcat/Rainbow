//
//  HSLColorConverter.swift
//  Rainbow
//
//  Created by Rainbow on 16/7/25.
//

import Foundation

public typealias HSL = (hue: Double, saturation: Double, lightness: Double)

struct HSLColorConverter {
    
    let hsl: HSL
    
    init(hue: Double, saturation: Double, lightness: Double) {
        // Normalize inputs
        // Hue: wrap around 360 degrees
        let normalizedHue = hue.truncatingRemainder(dividingBy: 360)
        let h = normalizedHue < 0 ? normalizedHue + 360 : normalizedHue
        
        // Saturation and Lightness: clamp to 0-100
        let s = min(max(saturation, 0), 100)
        let l = min(max(lightness, 0), 100)
        
        self.hsl = HSL(hue: h, saturation: s, lightness: l)
    }
    
    init(hsl: HSL) {
        self.init(hue: hsl.hue, saturation: hsl.saturation, lightness: hsl.lightness)
    }
    
    func toRGB() -> RGB {
        let h = hsl.hue / 360.0
        let s = hsl.saturation / 100.0
        let l = hsl.lightness / 100.0
        
        // Achromatic (gray)
        if s == 0 {
            let gray = UInt8(round(l * 255))
            return (gray, gray, gray)
        }
        
        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q
        
        let r = hueToRGB(p: p, q: q, t: h + 1/3)
        let g = hueToRGB(p: p, q: q, t: h)
        let b = hueToRGB(p: p, q: q, t: h - 1/3)
        
        return (
            UInt8(round(r * 255)),
            UInt8(round(g * 255)),
            UInt8(round(b * 255))
        )
    }
    
    private func hueToRGB(p: Double, q: Double, t: Double) -> Double {
        var t = t
        if t < 0 { t += 1 }
        if t > 1 { t -= 1 }
        
        if t < 1/6 { return p + (q - p) * 6 * t }
        if t < 1/2 { return q }
        if t < 2/3 { return p + (q - p) * (2/3 - t) * 6 }
        
        return p
    }
}