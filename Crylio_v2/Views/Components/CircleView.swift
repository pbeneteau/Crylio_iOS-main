//
//  CircleView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 04/05/2021.
//

import Foundation
import UIKit


public class CircleView: UIView {

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.width / 2
        layer.masksToBounds = true
    }

}
