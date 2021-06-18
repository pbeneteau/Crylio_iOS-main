//
//  BaseTableViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 18/06/2021.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    open var didMakeConstraints = false

    override func updateConstraints() {
        super.updateConstraints()
        
        if !didMakeConstraints {
            didMakeConstraints = true
            makeConstraints()
        }
    }
    
    open func makeConstraints() {
        
    }

}
