//
//  UserAssetsView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 21/05/2021.
//

import UIKit

class UserAssetsView: BaseView {
    
    lazy var filterMenuView = FilterMenuView()

    override func commonInit() {
        super.commonInit()
        
        addSubview(filterMenuView)
    }
    
}

// MARK: - Constraints

extension UserAssetsView {
    
    override func updateConstraints() {
        
        filterMenuView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(25)
        }
        
        super.updateConstraints()

    }
}
