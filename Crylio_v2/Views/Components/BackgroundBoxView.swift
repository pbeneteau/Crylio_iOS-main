//
//  RoundedCornersView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 01/02/2021.
//

import UIKit


class BackgroundBoxView: BaseView {
    
    /// The corner radius
    var cornerRadius: CGFloat = 10 {
        didSet {
            updateProperties()
        }
    }
    
    override func commonInit() {
        super.commonInit()
        
        backgroundColor = AppColors.background.secondary
        
        updateProperties()
                
        setNeedsUpdateConstraints()
    }
    
    fileprivate func updateProperties() {
        
        layer.cornerRadius = cornerRadius
    }
    
    
}
