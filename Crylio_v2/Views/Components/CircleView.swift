//
//  CircleView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 04/05/2021.
//

import Foundation
import UIKit


class CircleView: BaseView {
    
    override func commonInit() {
        super.commonInit()
        
        layer.masksToBounds = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.width / 2
    }
}
