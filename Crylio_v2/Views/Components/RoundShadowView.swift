//
//  RoundedCornersView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 01/02/2021.
//

import UIKit


class RoundShadowView: UIView {
    
    /// The corner radius of the `ShadowView`
    var cornerRadius: CGFloat = 10 {
        didSet {
            updateProperties()
        }
    }
    /// The shadow color of the `ShadowView`
    var shadowColor: UIColor = UIColor.black {
        didSet {
            updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`
    var shadowOffset: CGSize = CGSize(width: 0.0, height: 2) {
        didSet {
            updateProperties()
        }
    }
    /// The blur of the `ShadowView`
    var blur: CGFloat = 20 {
        didSet {
            updateProperties()
        }
    }
    /// The spread of the `ShadowView`
    var spread: CGFloat = 5 {
        didSet {
            updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`
    var shadowOpacity: Float = 0.05 {
        didSet {
            updateProperties()
        }
    }
    
    /**
     Masks the layer to it's bounds and updates the layer properties and shadow path.
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = false
        backgroundColor = AppColors.background.secondary
        
        updateProperties()
        updateShadowPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.masksToBounds = false
        
        updateProperties()
        updateShadowPath()
    }
    
    /**
     Updates all layer properties according to the public properties of the `ShadowView`.
     */
    fileprivate func updateProperties() {
        
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = blur / 2.0
        layer.shadowOpacity = shadowOpacity
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    /**
     Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
     */
    fileprivate func updateShadowPath() {
        
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: -spread, dy: -spread), cornerRadius: cornerRadius).cgPath
        }
    }
    
    /**
     Updates the shadow path everytime the views frame changes.
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateShadowPath()
    }
    
}
