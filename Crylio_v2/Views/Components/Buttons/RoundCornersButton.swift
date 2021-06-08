//
//  RoundCornersButton.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 21/05/2021.
//

import UIKit

class RoundCornersButton: UIButton {
    
    /// Border color of the view
    public var borderColor: UIColor? = nil {
        didSet {
            updateUI()
        }
    }
    
    /// Border width of the view
    public var borderWidth: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    /// Corner radius of the view
    public var cornerRadius: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Variables
    /// Closure is called on click event of the button
    public var onClick = { () }
        
    // MARK: - init methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        updateUI()
    }
    
    // MARK: - Update frame
    private func updateFrame() {
    }
    
    // MARK: - Update UI
    private func updateUI() {
        
        updateFrame()
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor ?? tintColor.cgColor
        
        if cornerRadius > 0 {
            layer.masksToBounds = true
        }
    }
    
}
