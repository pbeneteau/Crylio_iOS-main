//
//  CustomSearchBar.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 21/05/2021.
//

import UIKit


class CustomSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutMargins = UIEdgeInsets(top: 8, left: SAFE_AREA_MARGIN, bottom: 8, right: SAFE_AREA_MARGIN)
        
        layer.borderWidth = 1
        layer.borderColor = AppColors.background.primary.cgColor
        barTintColor = AppColors.background.primary
        backgroundColor = AppColors.background.primary
        searchTextField.font = .systemFont(ofSize: 15.0)
        placeholder = "Search"
        spellCheckingType = .no

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
