//
//  Extensions.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 08/06/2021.
//

import Foundation
import UIKit


extension CALayer {
    
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.07,
        x: CGFloat = 0,
        y: CGFloat = 5,
        blur: CGFloat = 100,
        spread: CGFloat = 10) {
        
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
}


extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat = 8) {
        
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func addDropShadow(shouldRasterize: Bool = true) {
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        if shouldRasterize {
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    func addBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = layer.cornerRadius
        blurEffectView.layer.masksToBounds = true
        addSubview(blurEffectView)
    }
}

