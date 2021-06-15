//
//  NumberFormatters.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 15/03/2021.
//

import Foundation
import UIKit


extension Float {
    
    
    func toDollarString(sign: Bool = false, precision: Int = 2) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = precision
        
        let number = NSNumber(value: self)
        
        return formatter.string(from: number)!
    }
    
    func toPercentString(sign: Bool = false) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        let number = NSNumber(value: self)
        
        return formatter.string(from: number)! + "%"
    }
    
    func toAmountString(sign: Bool = false, symbol: String = "") -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        if self < 100 {
            formatter.maximumFractionDigits = 6
        }
        
        let number = NSNumber(value: self)
        
        return formatter.string(from: number)! + "\(symbol)"
    }
    
    // =======
    
    func toDollarMutableString(fontSize: CGFloat, fontWeight: UIFont.Weight, colors: Bool = false, precision: Int = 2) -> NSMutableAttributedString {
        
        let dollarString = self.toDollarString(sign: colors, precision: precision)
        
        let mutableAttributedString = NSMutableAttributedString()
        
        if colors {
            mutableAttributedString.append(NSAttributedString(string: dollarString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight), NSAttributedString.Key.foregroundColor: self >= 0 ? AppColors.accent.green: AppColors.accent.red]))
        } else {
            mutableAttributedString.append(NSAttributedString(string: dollarString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight)]))
        }
        
        return mutableAttributedString
    }
    
    func toPercentMutableString(fontSize: CGFloat, fontWeight: UIFont.Weight, colors: Bool = false) -> NSMutableAttributedString {
        
        let percentString = self.toPercentString(sign: colors)
        
        let mutableAttributedString = NSMutableAttributedString()
        
        if colors {
            mutableAttributedString.append(NSAttributedString(string: percentString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight), NSAttributedString.Key.foregroundColor: self >= 0 ? AppColors.accent.green: AppColors.accent.red]))
        } else {
            mutableAttributedString.append(NSAttributedString(string: percentString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight)]))
        }
        
        return mutableAttributedString
    }
    
    func toAmountMutableString(fontSize: CGFloat, fontWeight: UIFont.Weight, symbol: String = "", sign: Bool = false) -> NSMutableAttributedString {
        
        let amountString = self.toAmountString(sign: sign)
        
        let mutableAttributedString = NSMutableAttributedString()
        
        mutableAttributedString.append(NSAttributedString(string: amountString + " \(symbol)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight)]))
        
        return mutableAttributedString
    }
    
}

extension UILabel {
    
    func setDollarMutableString(value: Float, colors: Bool = false, precision: Int = 2) {
        
        self.attributedText = value.toDollarMutableString(fontSize: self.font.pointSize, fontWeight: self.font.weight, colors: colors, precision: precision)
    }
    
    func setAmountMutableString(value: Float, symbol: String = "", sign: Bool = false) {
        
        self.attributedText = value.toAmountMutableString(fontSize: self.font.pointSize, fontWeight: self.font.weight, symbol: symbol, sign: sign)
    }
    
    func setPercentMutableString(value: Float, colors: Bool = false) {
        
        self.attributedText = value.toPercentMutableString(fontSize: self.font.pointSize, fontWeight: self.font.weight, colors: colors)
    }
}


extension UIFont {
    
    var weight: UIFont.Weight {
        
        guard let weightNumber = traits[.weight] as? NSNumber else { return .regular }
        let weightRawValue = CGFloat(weightNumber.doubleValue)
        let weight = UIFont.Weight(rawValue: weightRawValue)
        return weight
    }
    
    private var traits: [UIFontDescriptor.TraitKey: Any] {
        
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
            ?? [:]
    }
}


extension Float {
    
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
