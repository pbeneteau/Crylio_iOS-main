//
//  ArrowMacawView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 08/06/2021.
//

import Foundation
import Macaw


class ArrowMacawView: MacawView {
    
    let contents1 = [
        Shape(form: Line(x1: 6.31, y1: 10.06, x2: 11.5, y2: 15.71), stroke: Stroke(fill: Color(Int(AppColors.accent.primary.toHexInt())), width: 2, cap: .round)),
        Shape(form: Line(x1: 16.69, y1: 10.06, x2: 11.5, y2: 15.71), stroke: Stroke(fill: Color(Int(AppColors.accent.primary.toHexInt())), width: 2, cap: .round)),
    ]
    
    let contents2 = [
        Shape(form: Line(x1: 6.31, y1: 13.71, x2: 11.5, y2: 8.06), stroke: Stroke(fill: Color(Int(AppColors.accent.primary.toHexInt())), width: 2, cap: .round)),
        Shape(form: Line(x1: 16.69, y1: 13.71, x2: 11.5, y2: 8.06), stroke: Stroke(fill: Color(Int(AppColors.accent.primary.toHexInt())), width: 2, cap: .round)),
    ]
    
    var group: Group!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        group = contents1.group()
        node = group
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        group = contents1.group()
        super.init(node: group, coder: aDecoder)
        
        backgroundColor = .clear
    }
}
