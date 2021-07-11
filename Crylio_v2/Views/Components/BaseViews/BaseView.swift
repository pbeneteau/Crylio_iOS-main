//
//  BaseView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 18/06/2021.
//

import UIKit

class BaseView: UIView {

    open var didMakeConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if !didMakeConstraints {
            didMakeConstraints = true
            makeConstraints()
        }
    }
    
    @objc open dynamic func makeConstraints() {
    }
    
    open func commonInit() {
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
