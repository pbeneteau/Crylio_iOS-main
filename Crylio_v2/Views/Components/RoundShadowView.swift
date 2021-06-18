//
//  RoundedCornersView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 01/02/2021.
//

import UIKit


class RoundShadowView: BaseView {
    
    lazy var shadowView = UIView()
    
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
    
    /**
     Masks the layer to it's bounds and updates the layer properties and shadow path.
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        shadowView.layer.masksToBounds = false
        shadowView.backgroundColor = AppColors.background.secondary
        
        updateProperties()
        if traitCollection.userInterfaceStyle == .light {
            updateShadowPath()
        }
        
        addSubview(shadowView)
        
        setNeedsUpdateConstraints()
    }
    
    /**
     Updates all layer properties according to the public properties of the `ShadowView`.
     */
    fileprivate func updateProperties() {
        
        shadowView.layer.cornerRadius = cornerRadius
        
        if traitCollection.userInterfaceStyle == .light {
            
            shadowView.layer.shadowColor = shadowColor.cgColor
            shadowView.layer.shadowOffset = shadowOffset
            shadowView.layer.shadowRadius = blur / 2.0
            shadowView.layer.shadowOpacity = shadowOpacity
            
            shadowView.layer.shouldRasterize = shouldRasterize
            shadowView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    /**
     Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
     */
    fileprivate func updateShadowPath() {
        
        if spread == 0 {
            shadowView.layer.shadowPath = nil
        } else {
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds.insetBy(dx: -spread, dy: -spread), cornerRadius: cornerRadius).cgPath
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


class AnimatingShadowView: UIView {

    struct DropShadowParameters {
        var shadowOpacity: Float = 0
        var shadowColor: UIColor? = .black
        var shadowRadius: CGFloat = 0
        var shadowOffset: CGSize = .zero

        static let defaultParameters = DropShadowParameters(shadowOpacity: 0.15,
                                                            shadowColor: .black,
                                                            shadowRadius: 5,
                                                            shadowOffset: CGSize(width: 0, height: 1))
    }

    lazy var contentView = UIView()

    var shadowParameters: DropShadowParameters = DropShadowParameters.defaultParameters

    private func apply(dropShadow: DropShadowParameters) {
        let layer = self.layer
        layer.shadowColor = dropShadow.shadowColor?.cgColor
        layer.shadowOffset = dropShadow.shadowOffset
        layer.shadowOpacity = dropShadow.shadowOpacity
        layer.shadowRadius = dropShadow.shadowRadius
        layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(contentView)
        
        let layer = self.layer
        layer.backgroundColor = nil

        let contentLayer = self.contentView.layer
        assert(contentLayer.superlayer == layer, "contentView must be a direct subview of AnimatingShadowView!")

        self.apply(dropShadow: self.shadowParameters)

        let radius = contentLayer.cornerRadius
        layer.shadowPath = UIBezierPath(roundedRect: contentLayer.frame, cornerRadius: radius).cgPath
    }

    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        guard event == "shadowPath" else {
            return super.action(for: layer, forKey: event)
        }

        guard let priorPath = layer.shadowPath else {
            return super.action(for: layer, forKey: event)
        }

        guard let sizeAnimation = layer.animation(forKey: "bounds.size") as? CABasicAnimation else {
            return super.action(for: layer, forKey: event)
        }

        let animation = sizeAnimation.copy() as! CABasicAnimation
        animation.keyPath = "shadowPath"
        let action = ShadowingViewAction()
        action.priorPath = priorPath
        action.pendingAnimation = animation
        return action
    }
}


private class ShadowingViewAction: NSObject, CAAction {
    var pendingAnimation: CABasicAnimation? = nil
    var priorPath: CGPath? = nil

    // CAAction Protocol
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        guard let layer = anObject as? CALayer, let animation = self.pendingAnimation else {
            return
        }

        animation.fromValue = self.priorPath
        animation.toValue = layer.shadowPath
        layer.add(animation, forKey: "shadowPath")
    }
}
