//
//  Colors.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 27/01/2021.
//

import Foundation
import UIKit


class AppColors {
    
    struct background {
        static var primary: UIColor { return UIColor(hexString: "#f2f2f6") | .systemBackground}
        static var secondary: UIColor { return .systemBackground | UIColor(hexString: "#131621")}
        static var tertiary: UIColor { UIColor(hexString: "767680").withAlphaComponent(0.12) | UIColor(hexString: "767680").withAlphaComponent(0.24) }
    }
    
    struct foreground {
        static var primary: UIColor { return .systemGray6 | UIColor(hexString: "#131721")}
        static var secondary: UIColor { return .white | UIColor(hexString: "#181B26")}
        static var tertiary: UIColor { return .systemGray5 | UIColor(hexString: "#2a2c39") }
    }
    
    struct accent {
        static var primary: UIColor { return UIColor(hexString: "#0A84FF") | UIColor(hexString: "#007AFF")}
        static var red: UIColor { return UIColor(hexString: "#F6465D") | UIColor(hexString: "#F6465D")}
        static var green: UIColor { return UIColor(hexString: "#2EBD85") | UIColor(hexString: "#2EBD85")}
    }
    
    struct label {
        static var primary: UIColor { return .label }
        static var secondary: UIColor { return UIColor(red: 0.45, green: 0.48, blue: 0.52, alpha: 1.00) }
        static var tertiary: UIColor { return UIColor(red: 0.56, green: 0.55, blue: 0.56, alpha: 1.00) }
        static var primaryReversed: UIColor { return UIColor.white | UIColor.black }
    }
    
    static let action = UIColor(red: 0.21, green: 0.53, blue: 0.96, alpha: 1.00)
    
    
    
    static let icon = UIColor.label
    
    static let chart = [UIColor(red: 0.21, green: 0.47, blue: 0.80, alpha: 1.00),
                              UIColor(red: 0.86, green: 0.55, blue: 0.07, alpha: 1.00),
                              UIColor(red: 0.71, green: 0.38, blue: 0.78, alpha: 1.00),
                              UIColor(red: 0.22, green: 0.78, blue: 0.42, alpha: 1.00),
                              UIColor(red: 0.62, green: 0.92, blue: 0.33, alpha: 1.00),
                              UIColor(red: 0.00, green: 0.75, blue: 0.78, alpha: 1.00),
                              UIColor(red: 0.85, green: 0.20, blue: 0.56, alpha: 1.00),
                              UIColor(red: 0.87, green: 0.75, blue: 0.00, alpha: 1.00),
                              UIColor(red: 0.15, green: 0.55, blue: 0.43, alpha: 1.00),
                              UIColor(red: 0.56, green: 0.54, blue: 0.98, alpha: 1.00)]
    
    static let blur = .clear | .systemBlue.withAlphaComponent(0.1)
    
    static let buttonActiveBackground = .systemBlue.withAlphaComponent(0.3) | .systemBlue.withAlphaComponent(0.2)
    static let selectionBackground = .systemBlue.withAlphaComponent(0.2) | .systemBlue.withAlphaComponent(0.1)
     
}


infix operator |: AdditionPrecedence
public extension UIColor {
    
    /// Easily define two colors for both light and dark mode.
    /// - Parameters:
    ///   - lightMode: The color to use in light mode.
    ///   - darkMode: The color to use in dark mode.
    /// - Returns: A dynamic color that uses both given colors respectively for the given user interface style.
    static func | (lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}


extension UILabel {
    
    func setSpannedColor (fullText: String, changeText: String, color: UIColor) {
        
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = attribute
    }
}


extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"%06x", rgb)
    }
    
    func toHexInt() -> UInt {
        
        return UInt(self.toHexString(), radix: 16)!
    }
}


extension UIColor {

    func rgb() -> Int? {
        
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
