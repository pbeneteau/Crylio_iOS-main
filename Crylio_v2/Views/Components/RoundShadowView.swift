//
//  RoundShadowView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 01/07/2021.
//

import Foundation
import UIKit


class RoundShadowView: BaseView {
    
    lazy var shadowView = UIView()
    
    var forceShadowEnabled = false {
        didSet {
            updateProperties()
        }
    }
    
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
    var shadowOffset: CGSize = CGSize(width: 0.0, height: 1) {
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
    
    var shouldRasterize: Bool = true {
        didSet {
            updateProperties()
        }
    }
    
    var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            updateConstraints()
        }
    }
    
    var bgColor: UIColor = AppColors.background.secondary {
        didSet {
            shadowView.backgroundColor = bgColor
        }
    }
    
    override func commonInit() {
        super.commonInit()
        
        backgroundColor = .clear
        
        layer.masksToBounds = false
        shadowView.layer.masksToBounds = false
        shadowView.backgroundColor = bgColor
        
        updateProperties()
        
        addSubview(shadowView)
        
        setNeedsUpdateConstraints()
    }
    
    /**
     Updates all layer properties according to the public properties of the `ShadowView`.
     */
    fileprivate func updateProperties() {
        
        shadowView.layer.cornerRadius = cornerRadius
        
        if traitCollection.userInterfaceStyle == .light || forceShadowEnabled == true {
            
            shadowView.layer.shadowColor = shadowColor.cgColor
            shadowView.layer.shadowOffset = shadowOffset
            shadowView.layer.shadowRadius = blur / 2.0
            shadowView.layer.shadowOpacity = shadowOpacity
            
            shadowView.layer.shouldRasterize = shouldRasterize
            shadowView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    /**
     Updates the shadow path everytime the views frame changes. Also make it compatible with animations
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let oldShadowPath = shadowView.layer.shadowPath
        let newShadowPath = CGPath(rect: shadowView.bounds, transform: nil)
        
        if let boundsAnimation = shadowView.layer.animation(forKey: "bounds.size") as? CABasicAnimation {
            let shadowPathAnimation = CABasicAnimation(keyPath: "shadowPath")
            
            shadowPathAnimation.duration = boundsAnimation.duration
            shadowPathAnimation.timingFunction = boundsAnimation.timingFunction
            
            shadowPathAnimation.fromValue = oldShadowPath
            shadowPathAnimation.toValue = newShadowPath
            
            shadowView.layer.add(shadowPathAnimation, forKey: "shadowPath")
        }
        
        shadowView.layer.shadowPath = newShadowPath
    }
    
    override func makeConstraints() {
                 
        shadowView.snp.remakeConstraints { make in
            make.left.equalTo(insets.left)
            make.right.equalToSuperview().inset(insets.right)
            make.top.equalTo(insets.top)
            make.bottom.equalToSuperview().inset(insets.bottom)
        }
    }
    
}

